# frozen_string_literal: true

require 'dry/container'
require 'forwardable'

module Authcat
  module Identity
    module Identifier
      # @param base [Class]
      # @return [void]
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # @param attribute [Symbol, String]
        # @return [Symbol]
        def identifier(attribute, type: :token, **opts, &block)
          mod = type.is_a?(Module) ? type : Identifier.resolve(type)
          include mod.new(attribute, **opts, &block)

          attribute.to_sym
        end
      end

      class << self
        extend Forwardable

        def_delegators :registry, :register, :resolve

        def registry
          @registry ||= Dry::Container.new
        end
      end

      register(:email) { Email }
      register(:phone_number) { PhoneNumber }
      register(:token) { Token }
      register(:username) { Username }
    end
  end
end
