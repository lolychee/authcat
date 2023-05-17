# frozen_string_literal: true

require "test_helper"

class UserSessionTest < ActiveSupport::TestCase
  setup do
    @password = "123456"
  end

  test "sign in with login & password" do
    user = users(:one)

    session = UserSession.new(auth_method: "password")

    session.sign_in(login: user.email, password_challenge: @password)

    assert session.authenticated?
    assert session.persisted?
  end

  test "sign in with email & password" do
    user = users(:one)

    session = UserSession.new(auth_method: :login)

    assert session.sign_in(email: user.email)
    assert session.authenticating?
    assert session.sign_in(password_challenge: @password)

    assert session.authenticated?
    assert session.persisted?
  end

  test "sign in with email & password & one_time_password" do
    user = users(:two)

    session = UserSession.new(auth_method: :login)

    assert session.sign_in(email: user.email)
    assert session.authenticating?
    assert session.sign_in(auth_method: "password", password_challenge: @password)

    assert session.two_factor_authenticating?
    assert session.sign_in(auth_method: "one_time_password", one_time_password_challenge: user.one_time_password.now)

    assert session.authenticated?
    assert session.persisted?
  end

  test "sign in with email & password & recovery_codes" do
    user = users(:two)

    session = UserSession.new(auth_method: "login")

    assert session.sign_in(email: user.email)

    assert session.authenticating?
    assert session.sign_in(password_challenge: "123456")

    assert session.two_factor_authenticating?

    assert session.sign_in(auth_method: :recovery_codes, recovery_codes_challenge: "qwerty")

    assert session.authenticated?
    assert session.persisted?
  end
end
