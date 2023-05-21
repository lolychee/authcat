# frozen_string_literal: true

class UserWebAuthnCredential < ActiveRecord::Base
  include Authcat::WebAuthn::Record

  belongs_to :user
end
