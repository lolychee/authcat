# frozen_string_literal: true

class UserSession < ActiveRecord::Base
  include Authcat::Session::Record

  belongs_to :user
end
