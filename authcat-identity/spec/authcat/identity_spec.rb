# frozen_string_literal: true

RSpec.describe Authcat::Identity do
  let(:email) { "email@example.com" }

  it "do some thing" do
    User.create(email: email)

    user = User.new(email: email)

    expect(user.valid?(:email_sign_in)).to be true
    expect(user.id).to be_present
    expect(user.new_record?).to be false
  end
end
