# frozen_string_literal: true

module Authcat
  module Identity
    class Type
      class Email < Module
        DEFAULT_VALIDATIONS_OPTIONS = { 'valid_email_2/email': true }.freeze
        DEFAULT_MASK_OPTIONS = { pattern: /^.{1}(?<name_mask>.*).{2}@.{1}(?<domain_mask>.*)\..+$/ }.freeze
        DEFAULT_ENCRYPT_OPTIONS = { query: { expression: ->(v) { v.downcase } } }.freeze

        def initialize(attribute, encrypt: true, validations: true, mask: true)
          super()

          modules = []
          modules << Mask.new(attribute, **(mask.is_a?(Hash) ? mask : DEFAULT_MASK_OPTIONS)) if mask
          modules << Encryption.new(attribute, **(encrypt.is_a?(Hash) ? encrypt : DEFAULT_ENCRYPT_OPTIONS)) if encrypt

          define_singleton_method(:included) do |base|
            if validations
              gem 'valid_email2'
              require 'valid_email2'
              base.validates attribute, **(validations.is_a?(Hash) ? validations : DEFAULT_VALIDATIONS_OPTIONS)
              base.validates attribute, presence: true, uniqueness: true, on: :save
            end
            modules.each { |mod| base.include mod }
          end
        end
      end
    end
  end
end
