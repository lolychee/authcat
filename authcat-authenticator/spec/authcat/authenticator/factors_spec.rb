# frozen_string_literal: true

RSpec.describe Authcat::Authenticator::Factors do
  before do
    stub_const(
      "User",
      Class.new(ActiveRecord::Base) do
        include Authcat::Authenticator::Factors

        self.table_name = "users"
      end
    )
  end

  let(:email) { "email@example.com" }
  let(:user) { User.create(email:) }

  describe ".identify_by" do
    it "does something" do
      # Add your test code here
    end
  end

  describe ".auth_factors" do
    it "defines a factor" do
      User.auth_factors(:email, :id)

      expect(User.authentication_factors).to include(:email, :id)
    end
  end

  describe ".auth_factor" do
    it "defines a factor" do
      User.auth_factor(:email)

      expect(User.authentication_factors).to include(:email)
    end

    context "with serializer" do
      it "defines a factor" do
        User.auth_factor(:email, serializer: :base64)

        expect(User.authentication_factors).to include(:email)
        token = user.issue_factor(:email)
        expect(token).to eq(Base64.strict_encode64(email))
        expect(User.identify_by(email: token)).to eq(user)
      end
    end
  end
end
