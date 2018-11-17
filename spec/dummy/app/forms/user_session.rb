# frozen_string_literal: true

class UserSession
  include ActiveModel::Model
  include ActiveModel::Attributes

  include Authcat::Model

  attribute :identifier,  :string
  attribute :password,    :string
  attribute :remember_me, :boolean
  attribute :token,       :string
  attribute :otp_code,    :string

  attr_accessor :user
  delegate :password_verify, :two_factor_authentication_required?, to: :user, allow_nil: true

  with_options on: :password do
    validates :identifier, presence: true
    validate :identifier_should_founded
    validates :password, presence: true, password_verify: true
  end

  with_options on: :two_factor_authentication do
    validate :token_should_founded
    validate :otp_code_should_match
  end

  def sign_in(*)
    if token
      valid?(:two_factor_authentication)
    else
      valid?(:password) && !two_factor_authentication_required?
    end
  end

  def generate_token
    User.tokenize(user, expires_in: 5.minutes, secret_key: "user_session")
  end

  private

    def identifier_should_founded
      errors.add(:identifier, "not found") unless self.user = User.find_by_identifier(identifier)
    end

    def token_should_founded
      errors.add(:token, "not found") unless self.user = User.untokenize(token, secret_key: "user_session") rescue nil
    end

    def otp_code_should_match
      errors.add(:otp_code, "not match") unless self.user.otp_verify(otp_code)
    end
end
