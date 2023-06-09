# frozen_string_literal: true

require "aasm"

module Authcat
  module Credential
    module Authenticatable
      extend ActiveSupport::Concern

      included do
        include AASM
      end

      class Authenticator < AASM::Base
        attr_reader :options

        def setup!
          klass.enum auth_method: auth_methods.keys, _prefix: true

          define_states!
          define_events!

          self
        end

        def define_states!
          state :authenticating, initial: true
          state :authenticated, :expired
          state(*steps.keys)
        end

        def define_events!
          steps = self.steps.keys
          event :authenticate,
                before: -> { @_authenticate_valid = valid?(:authenticate) },
                guard: -> { @_authenticate_valid },
                after: -> { @_authenticate_valid = nil } do
            steps.each_cons(2).each do |from, to|
              transitions from: from, to: to, if: :"#{to}_required?"
              transitions from: to, to: :authenticated
            end
            transitions from: :authenticating, to: :authenticated
          end
        end

        def auth_methods
          @auth_methods ||= {}
        end

        def steps
          @steps ||= Hash.new { |hash, key| hash[key] = [] }
        end

        def auth_method(name, **options)
          validator = AuthMethod.new(name, options)
          auth_methods[name] = validator
          steps[validator.step] << validator
          klass.validate validator,
                         { on: :authenticate, if: [:"#{validator.step}?", :"auth_method_#{validator.name}?"] }
        end

        class AuthMethod
          attr_reader :name, :options

          def initialize(name, options)
            @name = name
            @options = options
          end

          def identifiers
            names = options[:identifier]
            case names
            when Hash
              names.compact
            else
              names = Array(names)
              (names.last.is_a?(Hash) ? names.pop : {}).reverse_merge(names.compact.to_h { |i| [i, i] })
            end
          end

          def verifiers
            names = options[:verifier]
            case names
            when Hash
              names.compact
            else
              names = Array(names)
              (names.last.is_a?(Hash) ? names.pop : {}).reverse_merge(names.compact.to_h { |i| [i, i] })
            end
          end

          def step
            options[:step] ||= :authenticating
          end

          def validate(record)
            identifiers.each do |name, identifer_name|
              validate_identifier(record, name, identifer_name)
            end

            verifiers.each do |name, verifier_name|
              validate_verifier(record, name, verifier_name)
            end
          end

          def with_identity(record)
            with = options[:with]
            if with
              identity = record.send(with)
              yield(identity).tap do |i|
                record.send("#{with}=", i) if i.respond_to?(:persisted?) && i.persisted?
              end
            else
              yield record
            end
          end

          def validate_identifier(record, name, identifier_name)
            found = with_identity(record) do |identity|
              identity.identify({ identifier_name => record.send(name) })
            end
            record.errors.add(name, :not_found) unless found
          end

          def validate_verifier(record, name, verifier_name)
            verified = with_identity(record) do |identity|
              identity.send(verifier_name) == record.send(name)
            end
            record.errors.add(name, :incorrect) unless verified
          end
        end
      end

      AASM_OPTIONS = {
        with_klass: Authenticator,
        column: :state
      }.freeze

      module Prepend
        def authenticate(attributes = {})
          assign_attributes(attributes)
          super()
        rescue AASM::InvalidTransition
          false
        end

        def authenticate!(attributes = {})
          assign_attributes(attributes)
          super()
        rescue AASM::InvalidTransition
          false
        end
      end

      module ClassMethods
        def authenticatable(name = :authenticator, *args, **options, &block)
          aasm(name, *args, **options.reverse_merge(AASM_OPTIONS), &block).setup!
          prepend Prepend
        end

        def authenticate(value, **opts); end
      end
    end
  end
end
