# frozen_string_literal: true

class UserPasskey < ActiveRecord::Base
  include Authcat::Passkey::Record

  belongs_to :user
end
