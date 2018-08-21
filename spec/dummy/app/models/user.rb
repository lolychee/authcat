class User < ApplicationRecord
  include Authcat::Model

  has_secure_password

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  with_options on: :save do
    validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
    validates :password_digest, presence: true
  end

  with_options on: :create do
    validates :password, presence: true, length: { minimum: 6, maximum: 72 }
  end

  attr_accessor :current_password, :password_confirmation
  with_options on: :change_password do
    validates :current_password, presence: true
    validate  :current_password_should_match
    validates :password, presence: true, confirmation: true
  end

  def change_password
    valid?(:change_password) && save
  end

  private

    def current_password_should_match
      errors.add(:current_password, "not match") unless self.password_digest_was.verify(self.current_password)
    end
end
