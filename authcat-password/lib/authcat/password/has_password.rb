# frozen_string_literal: true

module Authcat
  class Password
    module HasPassword
      # @return [void]
      def self.included(base)
        base.extend ClassMethods
        base.include Validators
      end

      module ClassMethods
        # @param Attribute [Symbol, String]
        # @param suffix [Symbol, String]
        # @param column_name [Symbol, String]
        # @param validate [Boolean]
        # @return [Symbol]
        def has_password(
          attribute = :password,
          validate: true,
          array: false,
          crypto: Password.default_crypto,
          **opts
        )
          serialize attribute, Coder.new(crypto: crypto, **opts)

          if validate
            include ActiveModel::Validations

            validates_presence_of attribute, on: :save

            validates_confirmation_of attribute, allow_nil: true
          end

          include InstanceMethodsOnActivation.new(attribute, array: array, **opts)

          attribute.to_sym
        end
      end

      class InstanceMethodsOnActivation < Module
        def initialize(attribute, array: false, **opts)
          super()

          define_method("#{attribute}=") do |plaintext|
            super(plaintext.nil? ? nil : Password.new(plaintext, crypto: :plaintext))
          end

          define_method("verify_#{attribute}") do |plaintext|
            !plaintext.nil? && send(attribute) == plaintext
          end
        end
      end
    end
  end
end
