# frozen_string_literal: true

module Authcat
  module Identity
    module Identification
      # @param base [Class]
      # @return [void]
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # @param attribute [Symbol, String]
        # @return [Symbol]
        def identity(attribute, type: :token, **opts, &block)
          mod = type.is_a?(Module) ? type : Type.resolve(type)
          include mod.new(attribute, **opts, &block)

          attribute.to_sym
        end
      end
    end
  end
end
