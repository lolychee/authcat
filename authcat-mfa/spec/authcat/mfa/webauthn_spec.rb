# frozen_string_literal: true

require "webauthn/fake_client"

RSpec.describe Authcat::MFA::WebAuthn do
  let(:origin) { "http://localhost.test" }
  let(:client) { WebAuthn::FakeClient.new(origin) }

  before do
    WebAuthn.configuration.origin = origin
  end

  it "has webauthn" do
    user = User.create(email: "example@email.com")
    user.generate_webauthn_options

    expect(user.webauthn_options).to be_a(WebAuthn::PublicKeyCredential::CreationOptions)
    expect(user.verify_webauthn(client.create(challenge: user.webauthn_challenge))).to be_truthy
    expect(user.webauthn_id).not_to be_empty
    expect(user.webauthn_public_key).not_to be_empty
    expect(user.webauthn_public_key.class).to eq(String)
    expect(user.webauthn_public_key.encoding).not_to eq(Encoding::BINARY)
    expect(user.webauthn_sign_count).to eq(0)

    user.reload
    user.generate_webauthn_options

    expect(user.webauthn_options).to be_a(WebAuthn::PublicKeyCredential::RequestOptions)
    expect(user.verify_webauthn(client.get(challenge: user.webauthn_challenge))).to be_truthy
    expect(user.webauthn_sign_count).to eq(1)
  end
end
