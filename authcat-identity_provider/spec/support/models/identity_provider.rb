# frozen_string_literal: true

class IdentityProvider < ActiveRecord::Base
  include Authcat::IdentityProvider::Record

  belongs_to :user

  self.identity_name = :user

  class Twitter < IdentityProvider
  end
end
