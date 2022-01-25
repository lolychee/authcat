# frozen_string_literal: true

require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  setup do
    @email = "test@email.com"
    @password = "123456"
    @user = User.create(email: @email, password: @password)
  end

  test "sign in with password" do
    visit sign_in_url
    fill_in "Email address", with: @email
    fill_in "Password", with: @password
    click_on "Sign in"

    assert_text "Homepage"
  end

  test "sign in with password & one-time-password" do
    @user.regenerate_one_time_password!
    @user.save

    visit sign_in_url
    fill_in "Email address", with: @email
    fill_in "Password", with: @password
    click_on "Sign in"

    assert_text "One time password"
    fill_in "One Time Code", with: @user.one_time_password.now
    click_on "Verify"

    assert_text "Homepage"
  end

  test "sign in with password & recovery code" do
    @user.regenerate_one_time_password
    codes = @user.regenerate_recovery_codes
    @user.save

    visit sign_in_url
    fill_in "Email address", with: @email
    fill_in "Password", with: @password
    click_on "Sign in"

    assert_text "One time password"
    click_on "Use recovery code"

    assert_text "Recovery code"
    fill_in "Recovery Code", with: codes.first
    click_on "Verify"

    assert_text "Homepage"
  end
end
