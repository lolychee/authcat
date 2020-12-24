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
        def has_backup_codes(attribute = :backup_codes, **opts, &block)
          gem 'authcat-password'
          require 'authcat/password'

          include Authcat::Password::HasPassword

          column_name = has_password attribute, array: true, validations: false, **opts

          block ||= begin
            require 'securerandom'
            ->(s = 8) { Array.new(s) { SecureRandom.hex(8) } }
          end

          include InstanceMethodsOnActivation.new(attribute, block)

          # @type [Symbol]
          column_name
        end
      end

      class InstanceMethodsOnActivation < Module
        # @return [void]
        def initialize(attribute, generator)
          super()

          define_method("regenerate_#{attribute}") do |*args|
            generator.call(*args).tap do |codes|
              update!(attribute => codes)
            end
          end

          define_method("verify_#{attribute}") do |code, burn: false|
            codes = send(attribute)
            passcode = codes.try(:find) { |c| c == code }
            update_column(attribute, codes - [passcode]) if burn && passcode
            !passcode.nil?
          end
        end
      end
    end
  end
end
