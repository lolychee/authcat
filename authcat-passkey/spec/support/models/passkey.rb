# frozen_string_literal: true

class Passkey < ActiveRecord::Base
  include Authcat::Passkey::Record

  belongs_to :user
  self.identity_name = :user
end
