# frozen_string_literal: true

RSpec.describe Authcat::Identity do
  let(:email) { "email@example.com" }
  let(:public_email) { "public_email@example.com" }
  let(:phone_number) { "13012345678" }

  it "identify by email" do
    User.create(email: email)

    user = User.new

    expect(user.identify({ email: email })).to be_a User
    expect(user.persisted?).to be true
  end

  it "identify by phone number" do
    User.create(phone_number: phone_number)

    user = User.new

    expect(user.identify({ phone_number: phone_number })).to be_a User
    expect(user.persisted?).to be true
  end

  it "identify by public_email" do
    User.create(public_email: public_email)

    user = User.new

    expect(user.identify({ public_email: public_email })).to be_a User
    expect(user.persisted?).to be true
  end

  it "identify by emails" do
    u = User.create(email: "2#{email}")
    u.emails.create(identifier: "2#{public_email}", identifier_type: "email")
    u.emails.create(identifier: "3#{public_email}", identifier_type: "email")

    user = User.new

    expect(user.identify({ emails: "2#{public_email}" })).to be_a User
    expect(user.persisted?).to be true
  end
end
