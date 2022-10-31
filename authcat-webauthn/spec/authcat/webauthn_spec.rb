# frozen_string_literal: true

require "webauthn/fake_client"

RSpec.describe Authcat::WebAuthn do
  let(:origin) { "http://localhost.test" }
  let(:user) { User.create(email: "user@email.com") }
  let(:user2) { User.create(email: "user2@email.com") }
  let(:client) { ::WebAuthn::FakeClient.new(origin) }

  before do
    ::WebAuthn.configuration.origin = origin
  end

  it "has webauthn" do
    expect(user.webauthn_user_id).not_to be_empty

    options = user.webauthn_credentials.options_for_create

    expect(options).to be_a(WebAuthn::PublicKeyCredential::CreationOptions)
    credential_json = client.create(challenge: options.challenge)
    credential = user.webauthn_credentials.create(name: :test, webauthn_credential: credential_json)

    expect(credential).to be_persisted
    expect(credential.public_key).not_to be_empty
    expect(credential.public_key.class).to eq(String)
    expect(credential.public_key.encoding).not_to eq(Encoding::BINARY)
    expect(credential.sign_count).to eq(0)

    user.reload
    options = user.webauthn_credentials.options_for_get
    expect(options).to be_a(WebAuthn::PublicKeyCredential::RequestOptions)

    credential_json = client.get(challenge: options.challenge)
    credential = user.webauthn_credentials.find(credential_json["id"])

    expect(credential).to be_persisted
    expect do
      expect(credential.verify(webauthn_credential: credential_json)).to be true
    end.to change(credential, :sign_count).by(1)
  end
end
