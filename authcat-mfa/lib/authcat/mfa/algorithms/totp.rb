# frozen_string_literal: true

gem "rotp"
require "rotp"

module Authcat
  module MFA
    module Algorithms
      module TOTP
        module_function

        def create(*args, **opts)
          new(::ROTP::Base32.random, **opts)
        end

        def new(ciphertext, **opts)
          Value.new(ciphertext.to_s, **opts)
        end

        def valid?(ciphertext, **opts)
          !ciphertext.nil? && ::ROTP::Base32.decode(ciphertext.to_s) && true
        rescue ::ROTP::Base32::Base32Error
          false
        end

        def verify(ciphertext, other, **verify_opts)
          otp = Value.new(ciphertext, **(@opts || {}))
          at = otp.verify(other.to_s, **verify_opts)
          return false if at.nil?

          last_used_at = Time.at(at)
          yield(last_used_at) if block_given?
          true
        end

        class Value < ::ROTP::TOTP
          prepend Authcat::Password::Verifiedable

          alias to_s secret
          alias as_json to_s

          def ==(other)
            !verify(other.to_s).nil?
          end
        end
      end
    end
  end
end
