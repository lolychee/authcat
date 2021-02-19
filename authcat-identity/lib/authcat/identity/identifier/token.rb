# frozen_string_literal: true

module Authcat
  module Identity
    module Identifier
      class Token < Module
        DEFAULT_VALIDATIONS_OPTIONS = { format: /^.+$/, allow_nil: true }.freeze

        def initialize(attribute, encrypt: true, mask: false, validations: false)
          super()

          define_singleton_method(:included) do |base|
            if encrypt
              base.include Encryption.new(attribute, **(encrypt.is_a?(Hash) ? encrypt : {}))
            end
            if mask
              base.include Mask
              base.mask attribute, **(mask.is_a?(Hash) ? mask : {})
            end
            if validations
              base.validates attribute, *(validations.is_a?(Hash) ? validations : DEFAULT_VALIDATIONS_OPTIONS)
            end
          end
        end
      end
    end
  end
end
