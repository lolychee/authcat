# frozen_string_literal: true

RSpec.describe Authcat::Password do
  let(:password) { "abc123456" }

  before { User.has_password }

  it "eager loads all files" do
    expect { Zeitwerk::Loader.eager_load_all }.not_to raise_error
  end

  # after { Object.send :remove_const, :User }

  it "does something useful" do
    user = User.create(email: "abc@email.com", password: password)

    expect(user).to be_persisted
    expect(user.password).to eq(password)
      .and be_a BCrypt::Password
    expect(user.password?).to be true
  end

  it "has_password support polymorphic" do
    user = User.create(email: "abc@email.com", password: password)
  end
end
