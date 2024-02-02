# frozen_string_literal: true

RSpec.describe Authcat::Session do
  let(:user) { User.create(email: "user@email.com") }
  let(:user2) { User.create(email: "user2@email.com") }
  let(:token) { "TOKEN" }

  it "has_many_sessions" do
    user.sessions.create(name: "foo", token: "#{token}1")
    user.sessions.create(name: "bar", token: "#{token}2")

    user = User.new

    expect(User.includes(:sessions).where(sessions: { token: "#{token}1" })).to be_exists
    expect(User.includes(:sessions).where(sessions: { token: "#{token}2" })).to be_exists
  end
end
