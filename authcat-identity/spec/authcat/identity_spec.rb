# frozen_string_literal: true

RSpec.describe Authcat::Identity do
  let(:email) { "email@example.com" }

  it "do some thing" do
    User.create(email: email)

    user = User.new(email: email)

    binding.irb

    expect(user.valid?(:email_sign_in)).to eq true
    expect(user.id).to be_present
    expect(user.new_record?).to eq false
  end
end
