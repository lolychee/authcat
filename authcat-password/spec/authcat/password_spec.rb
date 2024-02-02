# frozen_string_literal: true

RSpec.describe Authcat::Password do
  let(:password) { "abc123456" }

  before do
    stub_const(
      "User",
      Class.new(ActiveRecord::Base) do
        include Authcat::Password
        has_password
      end
    )
  end

  it "eager loads all files" do
    expect { Zeitwerk::Loader.eager_load_all }.not_to raise_error
  end

  it "does something useful" do
    user = User.create(email: "abc@email.com", password:)

    expect(user).to be_persisted
    expect(user.password).to eq(password)
      .and be_a BCrypt::Password
    expect(user.password?).to be true
  end
end
