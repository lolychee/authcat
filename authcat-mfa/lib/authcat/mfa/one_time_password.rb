# frozen_string_literal: true

require "authcat/password"
require "dry/container"
module Authcat
  module MFA
    module OneTimePassword
      # @return [void]
      def self.included(base)
        base.include Authcat::Password
        base.extend ClassMethods
      end

      module ClassMethods
        # @return [Symbol]
        def has_one_time_password(attribute = :one_time_password, engine: :totp, validate: false, **opts)
          engine = Password::Engines.resolve(engine) unless engine.is_a?(Module)

          result = has_password attribute, engine: engine, validate: validate, **opts
          include InstanceMethodsOnActivation.new(attribute, engine: engine)

          result
        end
      end

      class InstanceMethodsOnActivation < Module
        def initialize(attribute, engine:)
          super()

          define_method("regenerate_#{attribute}") do
            send("#{attribute}=", engine.create)
          end

          define_method("regenerate_#{attribute}!") do
            send("regenerate_#{attribute}") && save!
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
