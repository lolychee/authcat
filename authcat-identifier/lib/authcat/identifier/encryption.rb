# frozen_string_literal: true

module Authcat
  module Identifier
    class Encryption < Module
      def initialize(attribute, index: true, **opts)
        super()

        define_singleton_method(:included) do |base|
          gem 'lockbox'
          require 'lockbox'
          base.encrypts attribute, **opts

          if index
            gem 'blind_index'
            require 'blind_index'
            base.blind_index attribute, **(index.is_a?(Hash) ? index : {})
          end
        end
      end
    end
  end
end
