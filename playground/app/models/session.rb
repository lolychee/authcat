# frozen_string_literal: true

class Session < ApplicationRecord
  include Authcat::Identity

  belongs_to :user

  concerning :SignIn do
    included do
      validates :user, presence: true, on: :save

      attr_accessor :switch_to

      define_model_callbacks :sign_in

      set_callback :sign_in, :after, ->(model) { Current.session = model }

      attribute :login, :string
      validates :login, identify: { only: %w[phone_number email] }, on: :login, unless: -> { user.persisted? }
      validates :password, challenge: true, on: :login

      attribute :email, :string
      validates :email, identify: { only: :email }, on: :email, unless: :user

      attribute :phone_number, :string
      validates :phone_number, identify: { only: :phone_number }, on: :phone_number, unless: :user

      attribute :omniauth_hash
      validates :omniauth_hash, identify: { only: :omniauth_hash }, on: :omniauth_hash, unless: :user

      validates :password, challenge: { delegate: :user }, on: :password

      validates :one_time_password, challenge: { delegate: :user }, on: :one_time_password

      validates :recovery_codes, challenge: { delegate: :user }, on: :recovery_codes
      validates :webauthn_credentials, challenge: { delegate: :user }, on: :security_keys

      attribute :remember_me, :boolean

      attribute :sign_in_step, :string
      state_machine :sign_in_step, namespace: :sign_in, initial: :login, action: nil do
        state :login do
          transition to: :one_time_password, on: :submit, if: lambda { |record|
                                                                record.valid?(:login) && record.primary_tsv_method == :one_time_password
                                                              }
          transition to: :completed, on: :submit, if: ->(record) { record.valid?(:login) }
        end

        state :email do
          transition to: :password, on: :submit, if: lambda { |record|
                                                       record.valid?(:email) && record.primary_osv_method == :password
                                                     }
        end
        state :phone_number do
          transition to: :password, on: :submit, if: lambda { |record|
                                                       record.valid?(:phone_number) && record.primary_osv_method == :password
                                                     }
        end

        state :omniauth_hash do
          transition to: :completed, on: :submit, if: ->(record) { record.valid?(:omniauth_hash) }
        end

        state :password do
          transition to: :one_time_password, on: :submit, if: lambda { |record|
                                                                record.valid?(:password) && record.primary_tsv_method == :one_time_password
                                                              }
          transition to: :completed, on: :submit, if: ->(record) { record.valid?(:password) }
        end
        state :one_time_password do
          transition to: :recovery_codes, on: :submit, if: ->(record) { record.switch_to == "recovery_codes" }
          transition to: :security_keys, on: :submit, if: ->(record) { record.switch_to == "security_keys" }
          transition to: :completed, on: :submit, if: ->(record) { record.valid?(:one_time_password) }
        end
        state :recovery_codes do
          transition to: :one_time_password, on: :submit, if: ->(record) { record.switch_to == "one_time_password" }
          transition to: :security_keys, on: :submit, if: ->(record) { record.switch_to == "security_keys" }
          transition to: :completed, on: :submit, if: ->(record) { record.valid?(:recovery_codes) }
        end
        state :security_keys do
          transition to: :one_time_password, on: :submit, if: ->(record) { record.switch_to == "one_time_password" }
          transition to: :recovery_codes, on: :submit, if: ->(record) { record.switch_to == "recovery_codes" }
          transition to: :completed, on: :submit, if: ->(record) { record.valid?(:security_keys) }
        end

        event :submit do
          transition from: any - [:completed], to: same
        end
      end
    end

    def validate_user_status
      if user.locked?
        errors.add(:user, :locked)
      elsif user.blocked?
        errors.add(:user, :blocked)
      end
    end

    def identify(*args, **opts)
      build_user do |user|
        user.identify(*args, **opts)
      end
    end

    # after_sign_in do
    #   if user.reset_password_token.present?
    #     user.attributes = { reset_password_token: nil, reset_password_sent_at: nil }
    #   end

    #   if user.deactivated?
    #     user.activate = true
    #   end

    #   user.save
    # end

    def primary_osv_method
      return unless user

      :password if user.password?
    end

    def primary_tsv_method
      return unless user

      :one_time_password if user.one_time_password?
    end

    def sign_in(attributes = {}, &block)
      assign_attributes(attributes)

      submit_sign_in && sign_in_completed? && run_callbacks(:sign_in) { _sign_in(&block) }
    end

    def _sign_in(**)
      save
    end
  end

  concerning :SignOut do
    included do
      define_model_callbacks :sign_out
    end

    def sign_out(attributes = {}, &block)
      with_transaction_returning_status do
        assign_attributes(attributes)
        run_callbacks(:sign_out) { _sign_out(&block) }
      end
    end

    def _sign_out(**)
      destroy
    end
  end
end
