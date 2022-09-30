# frozen_string_literal: true

RSpec.describe Authcat::Password::Attribute do
  let(:password) { "abc123456" }

  # before { User.has_password }

  # after { Object.send :remove_const, :User }

  it "does something useful" do
    attribute = described_class.new(User, :password, array: false)
  end
end
