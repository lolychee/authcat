class User < ApplicationRecord
  include Authcat::Model

  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  # has_secure_password
  attr_accessor :password, :remember_me
  password_attribute :password_digest

  with_options on: :save do
    validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  end

  with_options on: :create do
    validates :password, presence: true, length: { minimum:6, maximum: 72 }
  end

  with_options on: :update do
    validates :password_digest, presence: true
  end

  with_options on: :sign_in do
    validates :email, presence: true, record_found: true
    validates :password, presence: true, verify_password: :password_digest
  end

  before_create do |user|
    user.write_password(:password_digest, user.password)
  end

  def remember_me=(value)
    @remember_me = value.is_a?(String) ? value == '1' : value
  end

end
