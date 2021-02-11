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
        def has_one_time_password(attribute = :otp, suffix: '_secret', column_name: "#{attribute}#{suffix}", after_attribute: "#{attribute}_last_used_at", drift: 30, **opts)
          gem 'rotp'
          require 'rotp'

          include InstanceMethodsOnActivation.new(attribute, column_name, after_attribute: after_attribute, drift: drift, **opts)

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

          define_method("verify_#{attribute}") do |code, drift: options[:drift], after: send(options[:after_attribute])|
            return false if code.nil?

            t = send(attribute).verify(code, drift_behind: drift, after: after)
            if t
              touch(options[:after_attribute], time: Time.at(t)) if options[:after_attribute]
              true
            else
              false
            end
          end
        end
      end
    end
  end
end
