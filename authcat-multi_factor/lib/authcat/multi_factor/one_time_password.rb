# frozen_string_literal: true

module Authcat
  module MultiFactor
    module OneTimePassword
      # @return [void]
      def self.included(base)
        gem "authcat-password"
        require "authcat/password"

        base.extend ClassMethods
      end

      module ClassMethods
        # @return [Symbol]
        def has_one_time_password(attribute = :one_time_password, type: :totp, **opts)
          include Authcat::Password::HasPassword,
                  Authcat::Password::Validators

          crypto = case type
                   when :totp then Crypto::TOTP
                   when :hotp then Crypto::HOTP
                   end

          result = has_password attribute, crypto: crypto, **opts
          include InstanceMethodsOnActivation.new(attribute)

          result
        end
      end

      class InstanceMethodsOnActivation < Module
        def initialize(attribute)
          super()

          define_method("regenerate_#{attribute}") do
            send("#{attribute}=", ::ROTP::Base32.random)
          end

          define_method("verify_#{attribute}") do |code, **opts|
            return false if code.nil?

            otp = send(attribute)

            !otp.nil? && otp.verify(code, **opts) do
              update(attribute => otp)
            end
          end
        end
      end
    end
  end
end
