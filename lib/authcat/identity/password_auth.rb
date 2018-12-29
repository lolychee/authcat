# frozen_string_literal: true

module Authcat
  module Identity
    module PasswordAuth
      def self.setup(base, update_password: true)
        base.include Password::SecurePassword,
                     Password::Validators,
                     self

        base.has_secure_password :password
        base.validates :password, presence: true, on: :create

        base.include UpdatePassword if update_password
      end

      def authenticate(password)
        password_verify(password) && self
      end

      module UpdatePassword
        def self.included(base)
          base.define_callbacks :update_password

          base.attr_accessor :old_password_needed
          base.attribute :old_password, :string

          base.validates :old_password, presence: true, password_verify: { with: :password, was: true }, if: :old_password_needed, on: :update_password
          base.validates :password, presence: true, confirmation: true, on: :update_password
        end

        def update_password
          valid?(:update_password) &&
          run_callbacks(:update_password) do
            save
          end
        end
      end
    end
  end
end
