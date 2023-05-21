# frozen_string_literal: true

class UserIdPCredential < ActiveRecord::Base
  include Authcat::IdP::Record

  belongs_to :user
end
