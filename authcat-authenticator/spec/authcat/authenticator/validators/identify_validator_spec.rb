# frozen_string_literal: true

RSpec.describe Authcat::Authenticator::Validators::IdentifyValidator do
  let(:email) { "email@example.com" }
  let(:password) { "abc123456" }

  before do
    stub_const(
      :User,
      Class.new(ActiveRecord::Base) do
        include Authcat::Authenticator::Validators

        self.table_name = "users"

        validates :email, identify: true, on: :password
      end
    )
  end

  describe "with email attribute" do
    before { User.create(email:, password:) }

    it "is valid" do
      user = User.new(email:)

      expect(user.valid?(:email)).to be true
      expect(user).to be_persisted
    end

    it "is invalid" do
      user = User.new(email: "wrong_email@example.com")

      expect(user.valid?(:email)).to be false
      expect(user).not_to be_persisted
    end
  end
end
