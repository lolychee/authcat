# frozen_string_literal: true

class User < ApplicationRecord
  include Authcat::Account
  include Authcat::Session
  include Authcat::IdP
  include Authcat::WebAuthn

  has_many_sessions dependent: :delete_all
  # has_many_passwords dependent: :delete_all
  has_many_webauthn_credentials dependent: :delete_all
  has_many_idp_credentials dependent: :delete_all

  has_identifier :email, type: :email
  has_identifier :phone_number, type: :phone_number

  has_identifier :login do |login|
    User.identify({ email: login, phone_number: login })
  end

  has_identifier :omniauth_hash do |auth_hash|
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
  has_password :one_time_password, type: :one_time_password
  has_many_passwords :recovery_codes, type: :one_time_password, algorithm: :bcrypt

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
  include Authcat::Account::EnableRecoveryCodes[:recovery_codes]
end
