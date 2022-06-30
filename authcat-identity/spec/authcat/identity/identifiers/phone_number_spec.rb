# frozen_string_literal: true

RSpec.describe Authcat::Identity::Identifiers::PhoneNumber do
  before do
    Phonelib.default_country = "CN"
  end

  let(:phone_number) { "13012341234" }
  let(:phone_number_masked) { "130****1234" }

  it "does something useful" do
    user = User.new(phone_number: phone_number)
    user.save

    expect(User.phone_number.identify(phone_number)).to be_persisted
    # expect(user.phone_number_masked).to eq phone_number_masked
  end
end
