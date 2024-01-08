# frozen_string_literal: true

require "spec_helper"

RSpec.describe Authcat::IdentityProvider::Record do
  let(:user) { User.create(email: Faker::Internet.email) }
  let(:credential) { OmniAuth::AuthHash.new(Faker::Omniauth.twitter) }
  let(:identity_provider) { user.identity_providers.create(credential) }

  describe "#create" do
    it "is successfully" do
      expect do
        identity_provider
      end.to change(user.identity_providers, :count).by(1)
    end
  end

  describe "#verify" do
    context "with OmniAuth::AuthHash object" do
      it "is valid" do
        identity_provider

        expect(user.identity_providers.verify(credential)).to be_truthy
      end
    end
  end
end
