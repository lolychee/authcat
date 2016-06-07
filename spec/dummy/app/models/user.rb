class User < ActiveRecord::Base
  include Authcat::Model

  # has_secure_password
  attr_accessor :password
  password_attribute :password_digest

  validates :email, presence: true, uniqueness: true

  validates :email, record_found: true, on: :sign_in
  validates :password, verify_password: :password_digest, on: :sign_in

  before_create {|user| user.create_password(:password_digest, user.password) }

end
