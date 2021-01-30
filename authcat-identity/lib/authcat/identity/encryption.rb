# frozen_string_literal: true

module Authcat
  module Identity
    class Encryption < Module
      DEFAULT_QUERY_OPTIONS = {}.freeze

      def initialize(attribute, query: true, **opts)
        super()

        define_singleton_method(:included) do |base|
          gem 'lockbox'
          require 'lockbox'
          base.encrypts attribute, **opts

          if query
            gem 'blind_index'
            require 'blind_index'
            base.blind_index attribute, **(query.is_a?(Hash) ? query : DEFAULT_QUERY_OPTIONS)
          end
        end
      end
    end
  end
end
