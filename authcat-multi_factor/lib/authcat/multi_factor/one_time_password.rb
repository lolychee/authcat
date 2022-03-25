# frozen_string_literal: true
require "dry/container"

module Authcat
  module MultiFactor
    module OneTimePassword
      class << self
        extend Forwardable

        def_delegators :registry, :register, :resolve

        def registry
          @registry ||= Dry::Container.new
        end
      end
      register(:totp) { Crypto::TOTP }
      register(:hotp) { Crypto::HOTP }

      # @return [void]
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # @return [Symbol]
        def has_one_time_password(attribute = :one_time_password, type: :totp, **opts)
          result = has_password attribute, crypto: OneTimePassword.resolve(type), **opts
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
