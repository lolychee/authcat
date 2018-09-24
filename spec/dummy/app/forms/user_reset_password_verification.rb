# frozen_string_literal: true

class UserResetPasswordVerification
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :identifier
  attr_accessor :user

  with_options unless: :user do
    validates :identifier, presence: true
    validate :identifier_should_founded
  end

  def self.locate(token)
    GlobalID::Locator.locate_signed(token, for: :user_reset_password)
  end

  def token
    user.to_sgid(expires_in: 15.minutes, for: :user_reset_password).to_s
  end

  def save(*)
    valid?(:save)
  end

  private

    def identifier_should_founded
      errors.add(:identifier, "not found") unless self.user = User.find_by_identifier(identifier)
    end
end
