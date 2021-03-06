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
        def has_one_time_password(
          attribute = :otp,
          suffix: '_secret',
          column: "#{attribute}#{suffix}",
          after_column: "#{attribute}_last_used_at",
          interval: 30,
          drift_ahead: 0,
          drift_behind: 30,
          **opts
        )
          include InstanceMethodsOnActivation.new(attribute, column, after_column: after_column, interval: interval, drift_ahead: drift_ahead, drift_behind: drift_behind, **opts)

          column.to_sym
        end
      end

      class InstanceMethodsOnActivation < Module
        def initialize(attribute, column, **options)
          gem 'rotp'
          require 'rotp'

          super()

          define_method(attribute) do
            secret = send(column)
            instance_variable_set("@#{attribute}", ::ROTP::TOTP.new(secret, issuer: options[:issuer])) if secret
          end

          define_method("regenerate_#{attribute}") do
            ROTP::Base32.random_base32.tap do |secret|
              update!(column => secret)
            end
          end

          define_method("verify_#{attribute}") do |
            code,
            drift_ahead: options[:drift_ahead],
            drift_behind: options[:drift_behind],
            after: send(options[:after_column])
          |
            return false if code.nil?

            t = send(attribute)?.verify(code, drift_ahead, drift_behind: drift, after: after)
            if t
              touch(options[:after_column], time: Time.at(t)) if options[:after_column]
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
