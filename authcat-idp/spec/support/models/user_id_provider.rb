# frozen_string_literal: true

class UserIdProvider < ActiveRecord::Base
  include Authcat::IdP::IdProviderRecord

  belongs_to :user
end
