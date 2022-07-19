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
        def has_one_time_password(attribute = :one_time_password, engine: :totp, validate: false, confirmation: false, after_verify: false, **opts)
          result = has_password attribute, engine: engine, validate: validate, **opts

          set_callback :"verify_#{attribute}", :after, after_verify if after_verify

          _password_instance_module.define_method("regenerate_#{attribute}") do |*args|
            update!(attribute => self.class.send(attribute).create(*args))
          end

          _password_instance_module.define_method("clear_#{attribute}") do
            update!(attribute => nil)
          end

          result
        end
      end
    end
  end
end
