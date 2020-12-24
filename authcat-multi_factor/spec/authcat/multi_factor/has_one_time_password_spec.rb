# frozen_string_literal: true

RSpec.describe Authcat::MultiFactor::HasOneTimePassword do
  it 'has one time password' do
    user = User.create(email: "test@email.com")
    user.regenerate_otp

    expect(user).to be_persisted
    expect(user.verify_otp(user.otp.now)).to be true
  end
end
