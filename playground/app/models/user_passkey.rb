# frozen_string_literal: true

class UserPasskey < ApplicationRecord
  include Authcat::Passkey::Record

  belongs_to :user
end
