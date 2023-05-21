# frozen_string_literal: true

require "webauthn/fake_client"

RSpec.describe Authcat::WebAuthn do
  let(:origin) { "http://localhost.test" }
  let(:user) { User.create(email: "user@email.com") }
  let(:user2) { User.create(email: "user2@email.com") }
  let(:client) { WebAuthn::FakeClient.new(origin) }

  before do
    WebAuthn.configuration.origin = origin
  end

  it "has_many_webauthn_credentials" do
    expect(user.webauthn_user_id).not_to be_empty

    options = user.webauthn_credentials.options_for_create

    expect(options).to be_a(WebAuthn::PublicKeyCredential::CreationOptions)

    challenge = options.challenge
    credential_json = client.create(challenge: challenge).to_json
    credential = user.webauthn_credentials.create(title: :test, credential_json: credential_json, challenge: challenge)

    expect(credential).to be_persisted
    expect(credential.public_key).not_to be_empty
    expect(credential.public_key.class).to eq(String)
    expect(credential.public_key.encoding).not_to eq(Encoding::BINARY)
    expect(credential.sign_count).to eq(0)

    user.reload
    options = user.webauthn_credentials.options_for_get
    expect(options).to be_a(WebAuthn::PublicKeyCredential::RequestOptions)

    challenge = options.challenge
    credential_json = client.get(challenge: challenge).to_json

    expect do
      expect(credential.verify(credential_json: credential_json, challenge: challenge)).to be true
    end.to change(credential, :sign_count).by(1)

    user.reload
    options = user.webauthn_credentials.options_for_get
    expect(options).to be_a(WebAuthn::PublicKeyCredential::RequestOptions)

    challenge = options.challenge
    credential_json = client.get(challenge: challenge).to_json

    expect(user.webauthn_credentials.verify(credential_json)).to be true
  end
end
