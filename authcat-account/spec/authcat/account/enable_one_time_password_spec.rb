# frozen_string_literal: true

RSpec.describe Authcat::Account::EnableOneTimePassword do
  before(:context) { User.include described_class[:one_time_password] }

  after(:context) { Object.send(:remove_const, :User) }

  let(:old_password) { "123456" }
  let(:new_password) { "qwerty" }

  it "enable one_time_password successfully" do
    user = User.create

    expect(user.one_time_password).to eq nil
    expect {
      user.enable_one_time_password
      user.enable_one_time_password
      otp = ROTP::TOTP.new(user.one_time_password)

      user.enable_one_time_password(one_time_password_attempt: otp.now)
    }.to change(user, :one_time_password)

    user.reload
    expect(user.one_time_password).to be_present
    expect(user.recovery_codes).to be_present
  end
end
