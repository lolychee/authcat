# frozen_string_literal: true

require "authcat"
require "zeitwerk"

Zeitwerk::Loader.for_gem_extension(Authcat).tap(&:setup)

module Authcat
  module Identifier
    def self.included(base)
      base.extend ClassMethods
      base.include Marcos
    end

    module ClassMethods
      def identifiers
        credentials.select do |_, credential|
          case credential
          when Association::Attribute, Association::HasOne, Association::HasMany
            true
          else
            false
          end
        end
      end

      def identify(value, **_opts)
        # attribute_names =
        #   if opts.key?(:only)
        #     identifier_attributes & Array(opts[:only]).map(&:to_s)
        #   elsif opts.key?(:except)
        #     identifier_attributes - Array(opts[:except]).map(&:to_s)
        #   else
        #     identifier_attributes
        #   end

        identifiers.each_value do |identifier|
          next unless value.key?(identifier.name)

          found = identifier.identify(value[identifier.name])
          return found if found
        end

        nil
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
