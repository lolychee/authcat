class UserWebAuthnCredential < ApplicationRecord
  include Authcat::WebAuthn::CredentialRecord

  belongs_to :user
end
