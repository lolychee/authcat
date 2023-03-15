# frozen_string_literal: true

class UserSession < ActiveRecord::Base
  include Authcat::Session::SessionRecord

  belongs_to :user
end
