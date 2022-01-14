# frozen_string_literal: true

RSpec.describe Authcat::Account::EnableOneTimePassword do
  class CustomUser < User
    include Authcat::Account::EnableOneTimePassword[:one_time_password]
  end

  let(:old_password) { "123456" }
  let(:new_password) { "qwerty" }

  it "enable one_time_password successfully" do
    user = CustomUser.create

    expect do
      user.enable_one_time_password # intro
      user.enable_one_time_password # recovery_codes
      otp = ROTP::TOTP.new(user.one_time_password)

      user.enable_one_time_password(one_time_password_attempt: otp.now)
    end.to change(CustomUser.where.not(one_time_password: nil, recovery_codes: nil), :count).by(1)
  end
end
