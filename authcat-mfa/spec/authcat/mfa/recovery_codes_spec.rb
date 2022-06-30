# frozen_string_literal: true

RSpec.describe Authcat::MFA::RecoveryCodes do
  it "has backup codes" do
    user = User.create(email: "test@email.com")
    codes = user.regenerate_recovery_codes

    expect(user).to be_persisted
    expect(user.recovery_codes).to include codes.first
    expect do
      expect(user.verify_recovery_codes(codes.first)).to eq true
    end.to change { user.recovery_codes.size }.by(-1)
  end
end
