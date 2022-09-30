# frozen_string_literal: true

require "rotp"

RSpec.describe Authcat::MFA::OneTimePassword do
  it "has one time password" do
    user = User.create(email: "test@email.com")
    user.regenerate_one_time_password

    expect(user).to be_persisted
    expect(user.one_time_password).to eq user.one_time_password.now
  end

  it "has recovery_code" do
    user = User.create(email: "test@email.com")
    password = "abc123456"
    user.regenerate_recovery_code(password)

    expect(user).to be_persisted

    expect(user.verify_recovery_code(password)).not_to eq false
    # expect(user.recovery_code.last_verified?).to eq true
  end

  it "has recovery_codes" do
    user = User.create(email: "test@email.com")
    passwords = ["abc123456"]
    user.regenerate_recovery_codes(passwords)

    expect(user).to be_persisted

    expect do
      expect(user.verify_recovery_codes(passwords.first)).not_to eq false
      end
    # end.to change(user, :recovery_codes).to([])
    # expect(user.recovery_codes.first.last_verified?).to eq true
  end
end
