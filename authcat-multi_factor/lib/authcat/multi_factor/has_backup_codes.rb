# frozen_string_literal: true

module Authcat
  module MultiFactor
    module HasBackupCodes
      # @return [void]
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # @return [Symbol]
        def has_backup_codes(attribute = :backup_codes, burn_after_verify: true, **opts, &block)
          gem 'authcat-password'
          require 'authcat/password'

          include Authcat::Password::HasPassword

          column = has_password attribute, array: true, validations: false, **opts

          include InstanceMethodsOnActivation.new(attribute, column, burn_after_verify: burn_after_verify, &block)

          # @type [Symbol]
          column
        end
      end

      class InstanceMethodsOnActivation < Module
        # @return [void]
        def initialize(attribute, column, burn_after_verify:, &generator)
          super()

          define_method("regenerate_#{attribute}") do |len = 8|
            codes =
              if generator
                generator.call(len)
              else
                require 'securerandom'
                Array.new(len) { SecureRandom.hex(8) }
              end

            codes.tap do
              update!(attribute => codes)
            end
          end

          define_method("verify_#{attribute}") do |code, burn: burn_after_verify|
            codes = send(attribute)

            passcode = codes.try(:find) { |c| c == code }
            if passcode.nil?
              false
            else
              update_columns(column => codes - [passcode]) if burn
              true
            end
          end
        end
      end
    end
  end
end
