# frozen_string_literal: true

RSpec.describe Authcat::Identifier::Reflections::Attribute do
  let(:email) { "email@example.com" }
  let(:token) { "token" }
  let(:phone_number) { "13012345678" }

  before do
    stub_const("User", Class.new(ActiveRecord::Base) do
      include Authcat::Identifier

      has_identifier :email
      has_identifier :phone_number, type: :phone_number, country: "CN"
    end)
  end

  it "identify by email" do
    User.create(email:)

    user = User.new

    expect(user.identify({ email: })).to be_persisted
  end

  it "identify by phone number" do
    User.create(phone_number:)

    user = User.new

    expect(user.identify({ phone_number: })).to be_persisted
  end
end
