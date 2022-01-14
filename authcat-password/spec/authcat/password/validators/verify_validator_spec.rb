# frozen_string_literal: true

RSpec.describe Authcat::Password::Validators::VerifyValidator do
  let(:email) { "email@example.com" }
  let(:password) { "abc123456" }

  before do
    User.attr_accessor :password_attempt
    User.validates :password_attempt, verify: :password, on: :sign_in
  end

  # after { Object.send :remove_const, :User }

  it "" do
    user = User.create(email: email, password: password)

    user.password_attempt = password

    expect(user.valid?(:sign_in)).to eq true
  end
end
