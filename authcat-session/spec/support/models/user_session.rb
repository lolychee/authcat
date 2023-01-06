# frozen_string_literal: true

class UserSession < ActiveRecord::Base
  include Authcat::Session::SignIn

  belongs_to :user
end
