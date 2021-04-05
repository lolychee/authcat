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

          column = has_password attribute, array: true, validate: false, **opts

          include InstanceMethodsOnActivation.new(attribute, column, burn_after_verify: burn_after_verify, &block)

          # @type [Symbol]
          column
        end

        def generate_backup_codes(len = 8)
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

          define_method("regenerate_#{attribute}") do |*args|
            codes = self.class.generate_backup_codes(*args, &generator)

            codes.tap do
              update!(attribute => codes)
            end
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
