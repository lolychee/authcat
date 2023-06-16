# frozen_string_literal: true

require "test_helper"

class UserSessionTest < ActiveSupport::TestCase
  setup do
    @password = "123456"
    @recovery_code = "123456"
  end

  test "sign in with login & password" do
    user = users(:one)

    session = UserSession.new(auth_method: "password")

    session.authenticate!(email: user.email, password: @password)
    assert session.authenticated?
    assert session.persisted?
  end

  test "sign in with email & password & one_time_password" do
    user = users(:two)

    session = UserSession.new(auth_method: :password)

    assert session.authenticate!(email: user.email, password: @password)

    assert session.two_factor_authenticating?
    assert session.authenticate!(auth_method: "one_time_password",
                                 one_time_password: user.one_time_password.now)

    assert session.authenticated?
    assert session.persisted?
  end

  test "sign in with email & password & recovery_codes" do
    user = users(:two)

    session = UserSession.new(auth_method: "password")
    assert session.authenticating?

    assert session.authenticate!(login: user.email, password: @password)
    assert session.two_factor_authenticating?

    assert session.authenticate!(auth_method: "recovery_code",
                                 recovery_code: @recovery_code)
    assert session.authenticated?
    assert session.persisted?
  end
end
