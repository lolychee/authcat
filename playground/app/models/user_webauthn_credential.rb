# frozen_string_literal: true

class UserWebAuthnCredential < ApplicationRecord
  include Authcat::WebAuthn::Record

  belongs_to :user
end
