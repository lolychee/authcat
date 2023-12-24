# frozen_string_literal: true

RSpec.describe Authcat::Session do
  let(:user) { User.create(email: "user@email.com") }
  let(:user2) { User.create(email: "user2@email.com") }
  let(:token) { "TOKEN" }

  it "has_many_sessions" do
    user.sessions.create(name: "foo", token: "#{token}1")
    user.sessions.create(name: "bar", token: "#{token}2")

    user = User.new

    expect(user.identify({ sessions: "#{token}1" })).to be_persisted
    expect(user.identify({ sessions: "#{token}2" })).to be_persisted
  end
end
