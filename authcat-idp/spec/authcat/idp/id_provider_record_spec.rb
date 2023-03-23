# frozen_string_literal: true

require "spec_helper"

RSpec.describe Authcat::IdP::CredentialRecord do
  let(:user) { User.create(email: Faker::Internet.email) }
  let(:idp) { OmniAuth::AuthHash.new(Faker::Omniauth.google) }
  let(:user_idp_credential) { user.idp_credentials.create(idp) }

  describe "#create" do
    it "is successfully" do
      expect do
        user.idp_credentials.create(idp)
      end.to change(user.idp_credentials, :count).by(1)
    end
  end

  describe "#verify" do
    context "with OmniAuth::AuthHash object" do
      it "is valid" do
        user.idp_credentials.create(idp)

        expect(user.idp_credentials.verify(idp)).to be_truthy
      end
    end
  end
end
