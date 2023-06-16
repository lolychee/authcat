# frozen_string_literal: true

class UserSession < ApplicationRecord
  include Authcat::Session::Record

  belongs_to :user, optional: true, default: -> { User.new }

  attribute :login
  attribute :email
  attribute :password
  attribute :one_time_password
  attribute :recovery_code

  attribute :remember_me

  authenticatable do
    auth_method :login, identifier: :login, verifier: false, with: :user
    auth_method :password, identifier: %i[login email], with: :user
    auth_method :one_time_password, step: :two_factor_authenticating, with: :user
    auth_method :recovery_code, verifier: [recovery_code: :recovery_codes], step: :two_factor_authenticating,
                                with: :user
  end

  def two_factor_authenticating_required?
    user.one_time_password?
  end

  def valid_auth_method?(_auth_method)
    true
  end

  def default_auth_method
    :password
  end
end
