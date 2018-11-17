# frozen_string_literal: true

class UserResetPassword
  include ActiveModel::Model
  include ActiveModel::Attributes

  include Authcat::Model

  attribute :identifier
  attribute :token
  attribute :password
  attribute :password_confirmation
  attribute :current_password

  attr_accessor :user, :skip_current_password

  with_options on: :send_verification do
    validates :identifier, presence: true
    validate :identifier_should_founded
  end

  with_options on: :reset_password do
    validates :token, presence: true
    validate :token_should_founded
    validates :password, presence: true, confirmation: true, length: { minimum: 6, maximum: 72 }
    validates :current_password, password_verify: true, unless: :skip_current_password
  end

  def send_verification(*)
    valid?(:send_verification)
  end

  def current_password_verify(password)
    user.password_verify(password)
  end

  def reset_password
    valid?(:reset_password) && user.update!(password: password)
  end

  def generate_token
    User.tokenize(user, expires_in: 20.minutes, secret_key: "user_reset_password")
  end

  private

    def identifier_should_founded
      errors.add(:identifier, "not found") unless self.user = User.find_by_identifier(identifier)
    end

    def token_should_founded
      errors.add(:token, "not found") unless self.user = User.untokenize(token, secret_key: "user_reset_password") rescue nil
    end
end
