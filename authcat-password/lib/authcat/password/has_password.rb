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

            attr_accessor "#{attribute}_confirmation"

            validates_confirmation_of attribute, allow_nil: true
          end

          include InstanceMethodsOnActivation.new(attribute, column_name, **opts)

          column_name.to_sym
        end
      end

      class InstanceMethodsOnActivation < Module
        def initialize(attribute, column_name, array: false, algorithm: Password.default_algorithm, **opts)
          super()

          ivar = "@#{attribute}"

          if array
            # base.serialize attribute, Array if serialize

            define_method(attribute) do
              instance_variable_get(ivar) || begin
                array = send(column_name)
                instance_variable_set(ivar, if array.nil?
                                              nil
                                            else
                                              array.map do |str|
                                                ::Authcat::Password.new(str, algorithm: algorithm, **opts)
                                              end
                                            end)
              end
            end

            define_method("#{attribute}=") do |unencrypted_str|
              value =
                if unencrypted_str.respond_to?(:to_a)
                  unencrypted_str.to_a.map do |str|
                    str.nil? ? nil : ::Authcat::Password.create(str, algorithm: algorithm, **opts)
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
              instance_variable_get(ivar) || begin
                str = send(column_name)
                instance_variable_set(ivar, if str.nil?
                                              nil
                                            else
                                              ::Authcat::Password.new(str, algorithm: algorithm, **opts)
                                            end)
              end
            end

            define_method("#{attribute}=") do |unencrypted_str|
              value = if unencrypted_str.nil?
                        nil
                      else
                        ::Authcat::Password.create(unencrypted_str, algorithm: algorithm,
                                                                    **opts)
                      end
              send("#{column_name}=", value.to_s)
              instance_variable_set("@#{attribute}", value)
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
