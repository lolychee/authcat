# frozen_string_literal: true

require "rotp"

RSpec.describe Authcat::MultiFactor::OneTimePassword do
  it "has one time password" do
    user = User.create(email: "test@email.com")
    user.regenerate_one_time_password

    otp = ROTP::TOTP.new(user.one_time_password.to_s)

    expect(user).to be_persisted
    expect(user.verify_one_time_password(otp.now)).to be true
  end
end
