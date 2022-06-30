# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, ".rb")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.push_dir("#{__dir__}/..")
loader.setup

module Authcat
  module Identity
    # @param base [Class]
    # @return [void]
    def self.included(base)
      base.class.attr_accessor :identifier_attributes
      base.extend ClassMethods
      base.extend ActsAsIdentity
      base.include Validators
    end

    module ClassMethods
      # @param attribute [Symbol, String]
      # @return [Symbol]
      def identifier(attribute, type: :token, **opts)
        cast_type = Attribute.new(self, attribute, type: type, **opts).to_type

        attribute attribute, cast_type

        generated_identity_class_methods.module_eval do
          define_method(attribute) do
            type_for_attribute(attribute)&.attribute
          end
        end

        self.identifier_attributes ||= Set.new
        self.identifier_attributes |= [attribute.to_s]

        attribute.to_sym
      end

      def generated_identity_class_methods # :nodoc:
        @generated_identity_class_methods ||= begin
          mod = const_set(:GeneratedIdentityClassMethods, Module.new)
          private_constant :GeneratedIdentityClassMethods
          extend mod

          mod
        end
      end

      def generated_identity_methods # :nodoc:
        @generated_identity_methods ||= begin
          mod = const_set(:GeneratedIdentityMethods, Module.new)
          private_constant :GeneratedIdentityMethods
          include mod

          mod
        end
      end

      def identify(value, **opts)
        return if identifier_attributes.nil?

        attribute_names =
          if opts.key?(:only)
            identifier_attributes & Array(opts[:only]).map(&:to_s)
          elsif opts.key?(:except)
            identifier_attributes - Array(opts[:except]).map(&:to_s)
          else
            identifier_attributes
          end

        attribute_names.each do |attribute|
          identifier = send(attribute)
          next unless identifier.valid?(value)

          identity = identifier.identify(value)
          return identity if identity
        end

        nil
      end
    end
  end
end
