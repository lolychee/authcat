# frozen_string_literal: true

RSpec.describe Authcat::IdentityProvider do
  let(:user) { User.create(email: Faker::Internet.email) }
  let(:credential) { OmniAuth::AuthHash.new(Faker::Omniauth.twitter) }
  let(:identity_provider) { user.identity_providers.create(credential) }

  it "has_many_identity_providers" do
    identity_provider
    expect(user.identity_providers.verify(credential)).to be true
  end
end
