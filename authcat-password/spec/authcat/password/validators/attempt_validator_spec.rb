# frozen_string_literal: true

RSpec.describe Authcat::Password::Validators::AttemptValidator do
  let(:email) { "email@example.com" }
  let(:password) { "abc123456" }

  it "" do
    user = User.create(email: email, password: password)

    user.password_attempt = password

    expect(user.valid?(:sign_in)).to eq true
  end
end
