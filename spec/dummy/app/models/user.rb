class User < ApplicationRecord
  include Authcat::Model

  # has_secure_password
  has_password

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  validates :password_digest, presence: true

  with_options on: :create do
    validates :password, presence: true, length: { minimum: 6, maximum: 72 }
  end
end
