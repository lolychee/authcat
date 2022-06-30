# frozen_string_literal: true

gem "rotp"
require "rotp"

module Authcat
  module MFA
    module Engines
      module TOTP
        module_function

        def create(*args, **opts)
          new(::ROTP::Base32.random(*args), **opts)
        end

        def new(ciphertext, **opts)
          Value.new(ciphertext.to_s, **opts)
        end

        def valid?(ciphertext)
          ::ROTP::Base32.decode(ciphertext.to_s) && true
        rescue ::ROTP::Base32::Base32Error
          false
        end

        def verify(ciphertext, other, **verify_opts)
          otp = Value.new(ciphertext, **(@opts || {}))
          at = otp.verify(other.to_s, **verify_opts.merge(after: @last_used_at))
          return false if at.nil?

          @last_used_at = Time.at(at)
          yield(@last_used_at) if block_given?
          true
        end

        class Value < ::ROTP::TOTP
          alias to_s secret
          def ==(other)
            !verify(other.to_s).nil?
          end
        end
      end
    end
  end
end
