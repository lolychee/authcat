# frozen_string_literal: true

class User < ApplicationRecord
  include Authcat::Account
  include Authcat::Session
  include Authcat::IdP
  include Authcat::WebAuthn

  has_many_sessions dependent: :delete_all
  # has_many_password_credentials dependent: :delete_all
  has_many_webauthn_credentials dependent: :delete_all
  has_many_idp_credentials dependent: :delete_all

  identifier :email, as: :email
  identifier :phone_number, as: :phone_number

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
  has_password :one_time_password, as: :one_time_password
  has_password :recovery_codes, as: :one_time_password, algorithm: :bcrypt, array: true,
                                burn_after_verify: true

  extra_action :sign_up, do: :save

  extra_action :update_profile, do: :save

  def two_factor_authentication_required?
    one_time_password?
  end

  def default_auth_method
    "password"
  end

  def avaliable_identify_auth_methods
    %w[login]
  end

  def avaliable_auth_methods
    %w[password]
  end

  def avaliable_two_factor_auth_methods
    %w[one_time_password recovery_code]
  end

  def default_two_factor_auth_method
    one_time_password? ? "one_time_password" : "recovery_code"
  end

  include Authcat::Account::ChangePassword[:password]
  include Authcat::Account::EnableOneTimePassword[:one_time_password]
end
