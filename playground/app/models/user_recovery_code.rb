# frozen_string_literal: true

class UserRecoveryCode < ApplicationRecord
  include Authcat::Password::Record
  belongs_to :user

  has_password
end
