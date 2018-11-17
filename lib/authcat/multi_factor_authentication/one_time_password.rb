# frozen_string_literal: true

require "rotp"

module Authcat
  module MultiFactorAuthentication
    module OneTimePassword
      DEFAULT_OPTIONS = {
      }

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def has_one_time_password(attribute = :otp, column_name: "#{attribute}_secret", timestamp: "#{attribute}_at", drift: 30, **opts)
          mod = Module.new

          mod.class_eval <<-RUBY
            def #{attribute}
              return unless self.#{column_name}
              @#{attribute} ||= ::ROTP::TOTP.new(self.#{column_name}, issuer: #{opts[:issuer].inspect})
            end

            def #{attribute}_code(at: Time.now)
              #{attribute}.at(at)
            end

            def #{attribute}_verify(code, drift: #{drift.inspect}, timestamp: #{timestamp.inspect}, prior: nil)
              return if code.nil?
              if prior
                #{attribute}.verify_with_drift_and_prior(code, drift, prior)
              elsif timestamp
                t = #{attribute}.verify_with_drift_and_prior(code, drift, send(timestamp))
                if t
                  touch(timestamp, time: Time.at(t))
                  true
                else
                  false
                end
              end
            end

            def #{attribute}_provisioning_uri(account)
              #{attribute}.provisioning_uri(account)
            end

            def generate_#{attribute}
              self.#{column_name} = ROTP::Base32.random_base32
            end
          RUBY

          self.include mod
        end
      end
    end
  end
end
