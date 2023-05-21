# frozen_string_literal: true

RSpec.describe Authcat::Identity do
  let(:email) { "email@example.com" }
  let(:token) { "token" }
  let(:public_email) { "public_email@example.com" }
  let(:phone_number) { "13012345678" }

  it "identify by email" do
    User.create(email: email)

    user = User.new

    expect(user.identify({ email: email })).to be_persisted
  end

  it "identify by token" do
    User.create(token: token)

    user = User.new

    expect(user.identify({ token: token })).to be_persisted
  end

  it "identify by phone number" do
    User.create(phone_number: phone_number)

    user = User.new

    expect(user.identify({ phone_number: phone_number })).to be_persisted
  end

  it "identify by public_email" do
    User.create(public_email: public_email)

    user = User.new

    expect(user.identify({ public_email: public_email })).to be_persisted
  end

  it "identify by emails" do
    u = User.create(email: "2#{email}")
    u.emails.create(identifier: "2#{public_email}", identifier_type: "email")
    u.emails.create(identifier: "3#{public_email}", identifier_type: "email")

    user = User.new

    expect(user.identify({ emails: "2#{public_email}" })).to be_persisted
    expect(user.identify({ emails: "3#{public_email}" })).to be_persisted
  end
end
