# frozen_string_literal: true

require "rotp"

RSpec.describe Authcat::MFA::OneTimePassword do
  it "has one time password" do
    user = User.create(email: "test@email.com")
    user.regenerate_one_time_password

    expect(user).to be_persisted
    expect(user.one_time_password).to eq user.one_time_password.now
  end
end
