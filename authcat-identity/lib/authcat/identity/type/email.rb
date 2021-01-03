# frozen_string_literal: true

module Authcat
  module Identity
    class Type
      class Email < Module
        DEFAULT_VALIDATIONS_OPTIONS = { email: true }.freeze
        DEFAULT_MASK_OPTIONS = { pattern: /^.{1}(?<name_mask>.*).{2}@.{1}(?<domain_mask>.*)\..+$/ }.freeze

        def initialize(attribute, validations: true, mask: true, &block)
          super()

          modules = []
          modules << Mask.new(attribute, **(mask.is_a?(Hash) ? mask : DEFAULT_MASK_OPTIONS)) if mask

          define_singleton_method(:included) do |base|
            if validations
              gem 'email_validator'
              require 'email_validator'
              base.validates attribute, **(validations.is_a?(Hash) ? validations : DEFAULT_VALIDATIONS_OPTIONS)
            end
            modules.each { |mod| base.include mod }
          end
        end

      end
    end
  end
end
