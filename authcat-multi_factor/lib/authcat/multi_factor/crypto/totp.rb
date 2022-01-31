# frozen_string_literal: true

gem "rotp"
require "rotp"

module Authcat
  module MultiFactor
    module Crypto
      class TOTP < Authcat::Password::Crypto
        def generate(value)
          valid?(value) ? value : ::ROTP::Base32.random
        end

        def valid?(ciphertext)
          ::ROTP::Base32.decode(ciphertext) && true
        rescue ::ROTP::Base32::Base32Error
          false
        end

        def verify(ciphertext, other, **verify_opts)
          otp = ::ROTP::TOTP.new(ciphertext, **(@opts || {}))
          at = otp.verify(other.to_s, **verify_opts.merge(after: @last_used_at))
          return false if at.nil?

          @last_used_at = Time.at(at)
          yield(@last_used_at) if block_given?
          true
        end

        def now(ciphertext)
          otp = ::ROTP::TOTP.new(ciphertext, **(@opts || {}))
          otp.now
        end
      end
    end
  end
end
