# frozen_string_literal: true

module Authcat
  module Identifier
    module Types
      class PhoneNumber < Module
        DEFAULT_VALIDATIONS_OPTIONS = { phone: true, allow_nil: true }.freeze
        DEFAULT_MASK_OPTIONS = { pattern: /^\d{3}(?<mask>\d{4})\d{4}$/ }.freeze
        DEFAULT_ENCRYPT_OPTIONS = { index: { expression: ->(v) { Phonelib.parse(v).to_s } } }.freeze

        def initialize(attribute, encrypt: true, mask: true, validations: true)
          super()

          define_singleton_method(:included) do |base|
            if encrypt
              base.include Encryption.new(attribute, **(encrypt.is_a?(Hash) ? encrypt : DEFAULT_ENCRYPT_OPTIONS))
            end
            if mask
              base.include Mask
              base.mask attribute, **(mask.is_a?(Hash) ? mask : DEFAULT_MASK_OPTIONS)
            end
            if validations
              gem "phonelib"
              require "phonelib"
              base.validates attribute, **(validations.is_a?(Hash) ? validations : DEFAULT_VALIDATIONS_OPTIONS)
              base.validates attribute, presence: true, uniqueness: true, on: :save
            end
          end
        end
      end
    end
  end
end
