# frozen_string_literal: true

require "rotp"

module Authcat
  module MultiFactor
    module OneTimePassword
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def has_one_time_password(attribute = :otp, column_name: "#{attribute}_secret", timestamp: "last_#{attribute}_at", drift: 30, **opts)
          mod = Module.new

          mod.class_eval <<-RUBY
            def #{attribute}
              return unless self.#{column_name}
              @#{attribute} ||= ::ROTP::TOTP.new(self.#{column_name}, issuer: #{opts[:issuer].inspect})
            end

            def #{attribute}_code(at: Time.now)
              #{attribute}.at(at)
            end

            def #{attribute}_enabled
              !#{attribute}.nil? && !#{timestamp || "true"}.nil?
            end

            def #{attribute}_verify(code, drift: #{drift.inspect}, timestamp: #{timestamp.inspect}, after: nil)
              return if code.nil?
              if after
                #{attribute}.verify(code, drift_behind: drift, after: after)
              elsif timestamp
                t = #{attribute}.verify(code, drift_behind: drift, after: send(timestamp))
                if t
                  touch(timestamp, time: Time.at(t))
                  true
                else
                  false
                end
              end
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
