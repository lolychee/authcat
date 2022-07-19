# frozen_string_literal: true

require "test_helper"

class SessionTest < ActiveSupport::TestCase
  test "sign in with login & password" do
    user = users(:one)

    session = Session.new(sign_in_step: "login")

    assert session.sign_in_step, "login"
    assert session.sign_in(login: user.email, password_challenge: "123456")

    assert session.sign_in_step, "completed"
    assert session.persisted?
  end

  test "sign in with email & password" do
    user = users(:one)

    session = Session.new(sign_in_step: "email")

    assert session.sign_in_step, "email"
    assert session.sign_in(email: user.email)

    assert session.sign_in_step, "password"
    assert session.sign_in(password_challenge: "123456")

    assert session.sign_in_step, "completed"
    assert session.persisted?
  end

  test "sign in with email & password & one_time_password" do
    user = users(:two)

    session = Session.new(sign_in_step: "email")

    assert session.sign_in_step, "email"
    assert session.sign_in(email: user.email)

    assert session.sign_in_step, "password"
    assert session.sign_in(password_challenge: "123456")

    assert session.sign_in_step, "one_time_password"
    assert session.sign_in(one_time_password_challenge: user.one_time_password.now)

    assert session.sign_in_step, "completed"
    assert session.persisted?
  end

  test "sign in with email & password & recovery_codes" do
    user = users(:two)

    session = Session.new(sign_in_step: "email")

    assert session.sign_in_step, "email"
    assert session.sign_in(email: user.email)

    assert session.sign_in_step, "password"
    assert session.sign_in(password_challenge: "123456")

    assert session.sign_in_step, "one_time_password"
    assert session.sign_in(switch_to: "recovery_codes")

    assert session.sign_in_step, "recoverey_codes"
    assert_difference "session.user.recovery_codes.size", -1 do
      assert session.sign_in(recovery_codes_challenge: "qwerty")
    end

    assert session.sign_in_step, "completed"
    assert session.persisted?
  end
end
