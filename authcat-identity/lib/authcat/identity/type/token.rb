# frozen_string_literal: true

module Authcat
  module Identity
    class Type
      class Token < Module
        DEFAULT_VALIDATIONS_OPTIONS = { format: /^.+$/ }.freeze
        DEFAULT_MASK_OPTIONS = {}.freeze
        DEFAULT_ENCRYPT_OPTIONS = {}.freeze

        def initialize(attribute, validations: false, mask: false, encrypt: true)
          super()

          modules = []
          modules << Mask.new(attribute, **(mask.is_a?(Hash) ? mask : DEFAULT_MASK_OPTIONS)) if mask
          modules << Encryption.new(attribute, **(encrypt.is_a?(Hash) ? encrypt : DEFAULT_ENCRYPT_OPTIONS)) if encrypt

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
