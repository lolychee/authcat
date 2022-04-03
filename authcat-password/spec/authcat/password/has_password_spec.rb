# frozen_string_literal: true

RSpec.describe Authcat::Password::HasPassword do
  let(:password) { "abc123456" }

  before { User.has_password }

  # after { Object.send :remove_const, :User }

  it "does something useful" do
    user = User.create(email: "abc@email.com", password: password, password_confirmation: password)

    expect(user).to be_persisted
    expect(user.password).to eq password
    expect(user.password).to be_a Authcat::Password::Value
    expect(user.password?).to eq true
    expect(user.verify_password(password)).to eq true
  end
end
