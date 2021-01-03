# frozen_string_literal: true

module Authcat
  module Identity
    class Type
      class Token < Module
        DEFAULT_VALIDATIONS_OPTIONS = { format: /^.+$/ }.freeze
        DEFAULT_MASK_OPTIONS = {}.freeze

        def initialize(attribute, validations: false, mask: false, &block)
          super()

          modules = []
          modules << Mask.new(attribute, **(mask.is_a?(Hash) ? mask : DEFAULT_MASK_OPTIONS)) if mask

          define_singleton_method(:included) do |base|
            if validations
              base.validates attribute, *(validations.is_a?(Hash) ? validations : DEFAULT_VALIDATIONS_OPTIONS)
            end
            modules.each { |mod| base.include mod }
          end
        end
      end
    end
  end
end
