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
          suffix: '_digest',
          column_name: "#{attribute}#{suffix}",
          validate: true,
          array: false,
          **opts
        )
          serialize column_name, JSON if array && connection.adapter_name == 'SQLite'

          if validate
            include ActiveModel::Validations

            validates_presence_of column_name, on: :save

            attr_accessor "#{attribute}_confirmation"

            validates_confirmation_of attribute, allow_nil: true
          end

          include InstanceMethodsOnActivation.new(attribute, column_name, array: array, **opts)

          column_name.to_sym
        end
      end

      class InstanceMethodsOnActivation < Module
        def initialize(attribute, column_name, array: false, algorithm: Password.default_algorithm, **opts)
          super()

          ivar = "@#{attribute}"

          klass = array ? ::Authcat::Password::Collection : ::Authcat::Password

          define_method(attribute) do
            instance_variable_get(ivar) || begin
              value = send(column_name)
              instance_variable_set(ivar, if value.nil?
                                            nil
                                          else
                                            klass.new(value, algorithm: algorithm, **opts)
                                          end)
            end
          end

          define_method("#{attribute}=") do |unencrypted_str|
            value = if unencrypted_str.nil?
                      nil
                    else
                      klass.create(unencrypted_str, algorithm: algorithm, **opts)
                    end
            send("#{column_name}=", value)
            instance_variable_set("@#{attribute}", value)
          end
        end
      end
    end
  end
end
