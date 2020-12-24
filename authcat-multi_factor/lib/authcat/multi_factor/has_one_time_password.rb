# frozen_string_literal: true

module Authcat
  module MultiFactor
    module HasOneTimePassword
      # @return [void]
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # @return [Symbol]
        def has_one_time_password(attribute = :otp, suffix: '_secret', column_name: "#{attribute}#{suffix}", last_at: "#{attribute}_last_used_at", drift: 30, **opts)
          gem 'rotp'
          require 'rotp'

          include InstanceMethodsOnActivation.new(attribute, column_name, last_at: last_at, drift: drift, **opts)

          column_name.to_sym
        end
      end

      class InstanceMethodsOnActivation < Module
        def initialize(attribute, column_name, **options)
          super()

          define_method(attribute) do
            secret = send(column_name)
            instance_variable_set("@#{attribute}", ::ROTP::TOTP.new(secret, issuer: options[:issuer])) if secret
          end

          define_method("regenerate_#{attribute}") do
            ROTP::Base32.random_base32.tap do |secret|
              update!(column_name => secret)
            end
          end

          define_method("verify_#{attribute}") do |code, drift: options[:drift], after: send(options[:last_at])|
            if code.nil?
              false
            else
              t = send(attribute).verify(code, drift_behind: drift, after: after)
              touch(options[:last_at], time: Time.at(t)) if options[:last_at] && t
              !t.nil?
            end
          end
        end
      end
    end
  end
end
