class User < ActiveRecord::Base
  include Authcat::Model::Account

  # has_secure_password
  define_password_attribute :password

end
