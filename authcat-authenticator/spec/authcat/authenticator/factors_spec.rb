# frozen_string_literal: true

RSpec.describe Authcat::Authenticator::Factors do
  describe ".identify_by" do
    it "does something" do
      # Add your test code here
    end
  end

  describe ".identify_or_initialize_by" do
    it "does something" do
      # Add your test code here
    end
  end

  describe ".auth_factor" do
    before do
      stub_const(
        "User",
        Class.new(ActiveRecord::Base) do
          include Authcat::Authenticator::Factors

          self.table_name = "users"
        end
      )
    end

    it "defines an authentication factor" do
      User.auth_factors(:email, :id)

      expect(User.authentication_factors).to include(:email, :id)
    end
  end
end
