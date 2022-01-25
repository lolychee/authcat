# frozen_string_literal: true

module Authcat
  module Identifier
    module Types
      class Email < Module
        DEFAULT_VALIDATIONS_OPTIONS = { "valid_email_2/email": true, allow_nil: true }.freeze
        DEFAULT_MASK_OPTIONS = { pattern: /^.{1}(?<name_mask>.*).{2}@.{1}(?<domain_mask>.*)\..+$/ }.freeze
        DEFAULT_ENCRYPT_OPTIONS = { index: { expression: ->(v) { v&.downcase } } }.freeze

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
              gem "valid_email2"
              require "valid_email2"
              base.validates attribute, **(validations.is_a?(Hash) ? validations : DEFAULT_VALIDATIONS_OPTIONS)
              base.validates attribute, presence: true, uniqueness: true, on: :save
            end
          end
        end
      end
    end
  end
end
