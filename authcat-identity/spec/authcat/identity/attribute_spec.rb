# frozen_string_literal: true

RSpec.describe Authcat::Identity::Attribute do
  describe "#initialize" do
    it "return new attribute" do
      expect(described_class.new(User, :email)).to be_a(described_class)
    end
  end

  describe "#identify" do
    subject { described_class.new(User, :email, format: :email) }

    it "returns the value of the attribute" do
      user = User.create(email: "test@email.com", phone_number: "123456789")
      id = user.email

      expect(subject.identify(id)).to eq(user)
    end
  end
end
