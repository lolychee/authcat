# frozen_string_literal: true

RSpec.describe Authcat::Password::Validators::ChallengeValidator do
  let(:email) { "email@example.com" }
  let(:password) { "abc123456" }

  class CustomUser < User
    self.table_name = "users"

    attr_accessor :otp_code

    validates :password, challenge: true, on: :password

    validates :otp_code, challenge: { with: :one_time_password, suffix: nil }, on: :otp_code
  end

  context "with password attribute" do
    it "is valid" do
      user = CustomUser.create(email: email, password: password)

      user.password_challenge = password

      expect(user.valid?(:password)).to be true
    end

    it "is invalid" do
      user = CustomUser.create(email: email, password: password)

      user.password_challenge = "wrong_password"

      expect(user.valid?(:password)).to be false
    end
  end

  context "with one_time_password attribute" do
    it "is valid" do
      user = CustomUser.create(email: email, one_time_password: true)

      user.otp_code = user.one_time_password.now
      expect(user.valid?(:otp_code)).to be true
    end
  end
end
