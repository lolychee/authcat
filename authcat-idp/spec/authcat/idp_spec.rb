# frozen_string_literal: true

RSpec.describe Authcat::IdP do
  let(:user) { User.create(email: Faker::Internet.email) }
  let(:idp) { OmniAuth::AuthHash.new(Faker::Omniauth.google) }
  let!(:user_idp_credential) { user.idp_credentials.create(idp) }

  it "has_many_idp_credentials" do
    expect(user.idp_credentials.verify(idp)).to be true
  end
end
