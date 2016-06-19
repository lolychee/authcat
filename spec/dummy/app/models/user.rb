class User < ActiveRecord::Base
  include Authcat::Model

  # has_secure_password
  attr_accessor :password
  password_attribute :password_digest

  with_options on: :save do
    validates :email, presence: true, uniqueness: true
    validates :password_digest, presence: true
  end

  with_options on: :sign_in do
    validates :email, presence: true, record_found: true
    validates :password, presence: true, verify_password: :password_digest
  end

  before_create {|user| user.write_password(:password_digest, user.password) }

end
