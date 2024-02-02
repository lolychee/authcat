# frozen_string_literal: true

RSpec.describe Authcat::Authenticator::Validators::ChallengeValidator do
  let(:email) { "email@example.com" }
  let(:password) { "abc123456" }
  let(:user) { User.new(email:, password:, one_time_password: true) }

  before do
    stub_const(
      :User,
      Class.new(ActiveRecord::Base) do
        include Authcat::Authenticator::Validators

        self.table_name = "users"

        has_secure_password
        validates :password, challenge: true, on: :password

        validates :one_time_password, challenge: true, on: :one_time_password
      end
    )
  end

  context "with password attribute" do
    it "is valid" do
      user.password_challenge = password

      expect(user.valid?(:password)).to be true
    end

    it "is invalid" do
      user.password_challenge = "wrong_password"

      expect(user.valid?(:password)).to be false
    end
  end

  context "with one_time_password attribute" do
    it "is valid" do
      user.one_time_password_challenge = user.one_time_password.now
      expect(user.valid?(:one_time_password)).to be true
    end
  end
end
