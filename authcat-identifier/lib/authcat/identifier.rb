# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, '.rb')
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.push_dir("#{__dir__}/..")
loader.setup

module Authcat
  module Identifier
    # @param base [Class]
    # @return [void]
    def self.included(base)
      base.extend ClassMethods
      base.include Validators
      base.class_attribute :identifier_types, instance_accessor: false
      # base.identifier_types = Hash.new(Type.default_value)
    end

    module ClassMethods
      # @param attribute [Symbol, String]
      # @return [Symbol]
      def identifier(attribute, type: :token, **opts, &block)
        mod = type.is_a?(Module) ? type : Types.resolve(type)
        include mod.new(attribute, **opts, &block)

        attribute.to_sym
      end

      def define_identifier(attribute, type)

      end

      def identify(attributes)
        case attributes
        when String
          where.or(identifier_names(fuzzy_match: true).map {|name| { name => attributes } }).first
        when Hash
          where(attributes).first
        end
      end
    end
  end
end
