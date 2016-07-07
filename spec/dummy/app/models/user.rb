class User < ApplicationRecord
  include Authcat::Model

  attr_accessor :password
  password_attribute :password_digest

  with_options on: [:create, :save] do
    validates :email, presence: true, uniqueness: true
  end

  with_options on: :create do
    validates :password, presence: true
  end

  with_options on: :save do
    validates :password_digest, presence: true
  end

  before_create {|user| user.write_password(:password_digest, user.password) if user.password }

end
