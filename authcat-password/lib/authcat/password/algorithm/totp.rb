# frozen_string_literal: true

gem "rotp"
require "rotp"

module Authcat
  module Password
    module Algorithm
      class TOTP < ::ROTP::TOTP
        def self.valid?(ciphertext, **_opts)
          !ciphertext.nil? && ::ROTP::Base32.decode(ciphertext.to_s) && true
        rescue ::ROTP::Base32::Base32Error
          false
        end

        def self.create(*_args, **opts)
          new(::ROTP::Base32.random, **opts)
        end

        alias to_s secret
        alias as_json to_s

        def ==(other)
          !verify(other.to_s).nil?
        end
      end
    end
  end
end
