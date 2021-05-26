# frozen_string_literal: true

module Authcat
  module MultiFactor
    module RecoveryCodes
      # @return [void]
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # @return [Symbol]
        def has_recovery_codes(attribute = :recovery_codes, burn_after_verify: true, **opts, &block)
          gem 'authcat-password'
          require 'authcat/password'

          include Authcat::Password::HasPassword

          column = has_password attribute, array: true, validate: false, **opts

          include InstanceMethodsOnActivation.new(attribute, column, burn_after_verify: burn_after_verify, &block)

          # @type [Symbol]
          column
        end

        def generate_recovery_codes(len = 8)
          require 'securerandom'
          Array.new(len) {
            block_given? ? yield : SecureRandom.hex(8)
          }
        end
      end

      class InstanceMethodsOnActivation < Module
        # @return [void]
        def initialize(attribute, column, burn_after_verify:, &generator)
          super()

          regenerate_method_name = "regenerate_#{attribute}"

          define_method(regenerate_method_name) do
            codes = self.class.generate_recovery_codes(&generator)

            self.attributes = { attribute => codes }
            codes
          end

          define_method("#{regenerate_method_name}!") do
            send(regenerate_method_name) && save!
          end

          define_method("verify_#{attribute}") do |code, burn: burn_after_verify|
            codes = send(attribute)

            passcode = codes.try(:find) { |c| c == code }
            (!passcode.nil?).tap do |passed|
              update_columns(column => codes - [passcode]) if burn && passed
            end
          end
        end
      end
    end
  end
end
