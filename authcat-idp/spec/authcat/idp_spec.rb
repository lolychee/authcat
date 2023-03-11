# frozen_string_literal: true

RSpec.describe Authcat::IdP do
  let(:user) { User.create(email: Faker::Internet.email) }
  let(:idp) { OmniAuth::AuthHash.new(Faker::Omniauth.google) }
  let!(:user_id_provider) { user.id_providers.create(idp) }

  it "has_many_id_providers" do
    expect(user.id_providers.verify(idp)).to be true
  end
end
