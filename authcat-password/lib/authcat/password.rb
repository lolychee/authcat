# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, ".rb")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.inflector.inflect(
  "bcrypt" => "BCrypt"
)

loader.push_dir("#{__dir__}/..")
loader.setup

module Authcat
  module Password
    class << self
      # @return [Symbol, String, self]
      attr_accessor :default_engine

      def included(base)
        base.class.attr_accessor :password_attributes
        base.extend ClassMethods
        base.include Validators
      end

      # @param original [String]
      # @param other [String]
      # @return [Boolean]
      def secure_compare(original, other)
        original.bytesize == other.bytesize && OpenSSL.fixed_length_secure_compare(original, other)
      end
    end

    self.default_engine = :bcrypt
    module ClassMethods
      # @param Attribute [Symbol, String]
      # @param suffix [Symbol, String]
      # @param column_name [Symbol, String]
      # @param validate [Boolean]
      # @return [Symbol]
      def has_password(
        attribute = :password,
        validate: true,
        **opts
      )
        cast_type = Attribute.new(self, attribute, **opts).to_type

        attribute attribute, cast_type

        if validate
          include ActiveModel::Validations

          validates_presence_of attribute, allow_nil: true

          validates_confirmation_of attribute, allow_nil: true
        end

        _password_singleton_module.module_eval do
          define_method(attribute) do
            type_for_attribute(attribute)&.attribute
          end
        end

        self.password_attributes ||= Set.new
        self.password_attributes |= [attribute.to_s]

        attribute.to_sym
      end

      def _password_singleton_module # :nodoc:
        @_password_singleton_module ||= begin
          mod = Module.new
          extend mod
          mod
        end
      end

      def _password_instance_module # :nodoc:
        @_password_instance_module ||= begin
          mod = Module.new
          extend mod
          mod
        end
      end
    end
  end
end
