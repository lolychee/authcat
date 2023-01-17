# frozen_string_literal: true

class UserIdProvider < ApplicationRecord
  include Authcat::IdP::IdProviderRecord

  belongs_to :user
end
