# frozen_string_literal: true

require "webauthn/fake_client"

RSpec.describe Authcat::Passkey do
  let(:origin) { "http://localhost.test" }
  let(:user) { User.create(email: "user@email.com") }
  let(:user2) { User.create(email: "user2@email.com") }
  let(:client) { WebAuthn::FakeClient.new(origin) }

  before do
    WebAuthn.configuration.origin = origin
  end

  it "has_many_passkeys" do
    expect(user.webauthn_id).not_to be_empty

    options = nil
    expect do
      options = user.passkeys.options_for_create
    end.to change(user.passkeys.unsigned, :count).by(1)

    expect(options).to be_a(WebAuthn::PublicKeyCredential::CreationOptions)

    challenge = options.challenge
    credential_json = client.create(challenge:).to_json
    expect(user.passkeys.verify(credential_json)).to be true

    passkey = user.passkeys.signed.take
    expect(passkey).to be_persisted
    expect(passkey.public_key).not_to be_empty
    expect(passkey.public_key.class).to eq(String)
    expect(passkey.public_key.encoding).not_to eq(Encoding::BINARY)
    expect(passkey.sign_count).to eq(0)

    user.reload
    options = user.passkeys.options_for_get
    expect(options).to be_a(WebAuthn::PublicKeyCredential::RequestOptions)

    challenge = options.challenge
    credential_json = client.get(challenge:).to_json

    expect do
      expect(user.passkeys.verify(credential_json)).to be true
    end.to change { passkey.reload.sign_count }.by(1)

    user.reload
    options = user.passkeys.options_for_get
    expect(options).to be_a(WebAuthn::PublicKeyCredential::RequestOptions)

    challenge = options.challenge
    credential_json = client.get(challenge:).to_json

    expect(user.passkeys.verify(credential_json)).to be true
  end
end
