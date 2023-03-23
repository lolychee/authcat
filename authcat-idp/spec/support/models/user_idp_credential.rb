# frozen_string_literal: true

class UserIdPCredential < ActiveRecord::Base
  include Authcat::IdP::CredentialRecord

  belongs_to :user
end
