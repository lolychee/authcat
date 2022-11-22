# frozen_string_literal: true

class UserWebAuthnCredential < ActiveRecord::Base
  include Authcat::WebAuthn::CredentialRecord

  belongs_to :user
end
