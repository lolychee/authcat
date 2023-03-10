require "spec_helper"

RSpec.describe Authcat::IdP::IdProviderRecord do
  let(:user) { User.create(email: Faker::Internet.email) }
  let(:idp) { OmniAuth::AuthHash.new(Faker::Omniauth.google) }
  let(:user_id_provider) { user.id_providers.create(idp) }

  describe "#create" do
    it "is successfully" do
      expect do
        user.id_providers.create(idp)
      end.to change(user.id_providers, :count).by(1)
    end
  end

  describe "#verify" do
    context "with OmniAuth::AuthHash object" do
      it "is valid" do
        user.id_providers.create(idp)

        expect(user.id_providers.verify(idp)).to be_truthy
      end
    end
  end
end
