gem 'rotp'
require 'rotp'

module Authcat
  module MultiFactor
    module Crypto
      class TOTP < Authcat::Password::Crypto
        def generate(byte_length = 20)
          ::ROTP::Base32.random(byte_length.to_i)
        end

        def valid?(ciphertext)
          ::ROTP::Base32.decode(ciphertext)
        rescue ::ROTP::Base32::Base32Error
          false
        end

        def verify(ciphertext, other, **verify_opts)
          otp = ROTP::TOTP.new(ciphertext, **(@opts || {}))
          at = otp.verify(other, **verify_opts.merge(after: @last_used_at))
          return false if at.nil?

          @last_used_at = Time.at(at)
          yield(@last_used_at) if block_given?
          true
        end
      end
    end
  end
end
