# frozen_string_literal: true

module Authcat
  class Password
    module HasPassword
      # @return [void]
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # @param Attribute [Symbol, String]
        # @param suffix [Symbol, String]
        # @param column_name [Symbol, String]
        # @param validations [Boolean]
        # @return [Symbol]
        def has_password(
          attribute = :password,
          suffix: '_digest',
          column_name: "#{attribute}#{suffix}",
          validations: true,
          **opts
        )
          if validations
            include ActiveModel::Validations

            validates_presence_of column_name, on: :save

            attribute_comfirmation = "#{attribute}_confirmation"
            attr_accessor attribute_comfirmation

            validates_presence_of attribute_comfirmation, on: :create
            validates_confirmation_of attribute, on: :create
          end

          include InstanceMethodsOnActivation.new(attribute, column_name, **opts)

          column_name.to_sym
        end
      end

      class InstanceMethodsOnActivation < Module
        def initialize(attribute, column_name, array: false, **opts)
          super()
          encryptor = Encryptor.build(**opts)

          if array
            # base.serialize attribute, Array if serialize

            define_method(attribute) do
              array = send(column_name)
              array.nil? ? nil : array.map { |str| ::Authcat::Password.new(str, encryptor: encryptor) }
            end

            define_method("#{attribute}=") do |unencrypted_str|
              value =
                if unencrypted_str.respond_to?(:to_a)
                  unencrypted_str.to_a.map do |str|
                    str.nil? ? nil : ::Authcat::Password.create(str, encryptor: encryptor)
                  end
                end
              send("#{column_name}=", value)
              instance_variable_set("@#{attribute}", value)
            end

            define_method("verify_#{attribute}") do |unencrypted_str|
              passwords = send(attribute)
              !passwords.nil? && passwords.any? { |pwd| pwd == unencrypted_str }
            end
          else
            define_method(attribute) do
              str = send(column_name)
              str.nil? ? nil : ::Authcat::Password.new(str, encryptor: encryptor)
            end

            define_method("#{attribute}=") do |unencrypted_str|
              value = unencrypted_str.nil? ? nil : ::Authcat::Password.create(unencrypted_str, encryptor: encryptor)
              send("#{column_name}=", value)
              instance_variable_set("@#{attribute}", unencrypted_str)
            end

            define_method("verify_#{attribute}") do |unencrypted_str|
              send(attribute) == unencrypted_str
            end
          end
        end
      end
    end
  end
end
