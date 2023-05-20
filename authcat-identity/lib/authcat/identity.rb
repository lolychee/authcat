# frozen_string_literal: true

require "active_support"
require "authcat"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem_extension(Authcat)
loader.setup

module Authcat
  module Identity
    extend ActiveSupport::Concern

    include Marcos
    include Validators

    module ClassMethods
      def identifiers
        credentials.filter do |credential|
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

        identifiers.each_value.each do |identifier|
          found = identifier.identify(value[identifier.name])
          return found if found
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
