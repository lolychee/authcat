# frozen_string_literal: true

require "authcat"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem_extension(Authcat)
loader.setup

module Authcat
  module Identity
    # @param base [Class]
    # @return [void]
    def self.included(base)
      base.class.attr_accessor :identifier_attributes
      base.extend ClassMethods
      base.include Validators
    end

    module ClassMethods
      # @param attribute [Symbol, String]
      # @return [Symbol]
      def identifier(attribute, type: :token, **opts, &block)
        Attribute.new(self, attribute, **opts, &block).setup!

        self.identifier_attributes ||= Set.new
        self.identifier_attributes |= [attribute.to_s]

        attribute.to_sym
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
    end

    def identify(value, **opts)
      identity = self.class.identify(value, **opts)

      if identity
        if instance_variable_defined?(:@association_cache)
          @association_cache = identity.instance_variable_get(:@association_cache)
        end
        @attributes = identity.instance_variable_get(:@attributes)
        @new_record = false
        @previously_new_record = false if instance_variable_defined?(:@previously_new_record)
      end

      self
    end
  end
end
