# frozen_string_literal: true

RSpec.describe Authcat::Password::Validators::ChallengeValidator do
  let(:email) { "email@example.com" }
  let(:password) { "abc123456" }

  before do
    User.validates :password, challenge: :password, on: :sign_in
  end

  # after { Object.send :remove_const, :User }

  it "" do
    user = User.create(email: email, password: password)

    user.password_challenge = password

    expect(user.valid?(:sign_in)).to eq true
  end
end
