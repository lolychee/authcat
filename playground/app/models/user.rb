# frozen_string_literal: true

class User < ApplicationRecord
  include Authcat::Account
  include Authcat::Session
  include Authcat::IdP

  # has_many :sessions, dependent: :delete_all

  has_many_webauthn_credentials
  has_many_sessions
  has_many_id_providers

  identifier :email, format: :email
  identifier :phone_number, format: :phone_number
  # identifier :github_oauth_token, format: :token
  # identifier :google_oauth_token, format: :token

  identifier :omniauth_hash do |auth_hash|
    case auth_hash.provider
    when "developer"
      User.email.identify(auth_hash.uid)
    when "github"
      User.find_or_create_by(github_oauth_token: auth_hash.uid) do |u|
        u.name = auth_hash.info.nickname
      end
    end
  end

  has_password
  has_one_time_password
  has_one_time_password :recovery_codes, algorithm: :bcrypt, array: true, burn_after_verify: true

  concerning :SignUp do
    included do
      define_model_callbacks :sign_up
    end

    def sign_up(attributes = {}, &block)
      with_transaction_returning_status do
        assign_attributes(attributes)
        valid?(:sign_up) && run_callbacks(:sign_up) { _sign_up(&block) }
      end
    end

    def _sign_up(**)
      save
    end
  end

  concerning :UpdateProfile do
    included do
      define_model_callbacks :update_profile
    end

    def update_profile(attributes = {}, &block)
      with_transaction_returning_status do
        assign_attributes(attributes)
        valid?(:update_profile) && run_callbacks(:update_profile) { _update_profile(&block) }
      end
    end

    def _update_profile(**)
      save
    end
  end

  include Authcat::Account::ChangePassword[:password]
  include Authcat::Account::EnableOneTimePassword[:one_time_password]
end
