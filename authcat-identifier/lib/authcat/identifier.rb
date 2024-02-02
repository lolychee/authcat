# frozen_string_literal: true

require "zeitwerk"

module Authcat
  module Identifier
    def self.loader
      @loader ||= Zeitwerk::Loader.for_gem_extension(Authcat)
    end

    loader.setup

    def self.included(base)
      # base.extend ClassMethods
      base.include Marcos
    end

    # module ClassMethods
    #   def identify(value, **_opts)
    #     # attribute_names =
    #     #   if opts.key?(:only)
    #     #     identifier_attributes & Array(opts[:only]).map(&:to_s)
    #     #   elsif opts.key?(:except)
    #     #     identifier_attributes - Array(opts[:except]).map(&:to_s)
    #     #   else
    #     #     identifier_attributes
    #     #   end
    #     identifiers = credential_reflections.select do |_, credential|
    #       credential.identifiable?
    #     end

    #     if value.is_a?(Hash)
    #       value.each do |key, value|
    #         next if !value.present? || !identifiers.key?(key.to_sym)

    #         found = identifiers[key.to_sym].identify(value)
    #         return found if found
    #       end
    #     else
    #       value = value.to_s
    #       identifiers.each_value do |identifier|
    #         next if !value.present? || !identifier.identifiable? || !identifier.fuzzy_search?

    #         found = identifier.identify(value)
    #         return found if found
    #       end
    #     end

    #     nil
    #   end
    # end

    # def identify(value, **)
    #   identity = self.class.identify(value, **)

    #   if identity
    #     if instance_variable_defined?(:@association_cache)
    #       @association_cache = identity.instance_variable_get(:@association_cache)
    #     end
    #     @attributes = identity.instance_variable_get(:@attributes)
    #     @new_record = false
    #     @previously_new_record = false if instance_variable_defined?(:@previously_new_record)
    #   end

    #   self
    # end
  end
end
