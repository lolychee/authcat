# frozen_string_literal: true

require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  setup do
    @email = "test@email.com"
    @password = "123456"
    @user = users(:one)
    @user2 = users(:two)
  end

  test "sign in with password" do
    visit sign_in_url

    fill_in "Login", with: @user.email
    fill_in "Password", with: @password
    click_on "Sign in"

    assert_text "Homepage"
  end

  test "sign in with password & one-time-password" do
    visit sign_in_url

    fill_in "Login", with: @user2.email
    fill_in "Password", with: @password
    click_on "Sign in"

    assert_text "One Time Code"
    fill_in "One Time Code", with: @user2.one_time_password.now
    click_on "Verify"

    assert_text "Homepage"
  end

  test "sign in with password & recovery code" do
    visit sign_in_url

    fill_in "Login", with: @user2.email
    fill_in "Password", with: @password
    click_on "Sign in"

    assert_text "One Time Code"
    click_on "Use recovery code"

    assert_text "Recovery code"
    fill_in "Recovery Code", with: "qwerty"
    click_on "Verify"

    assert_text "Homepage"
  end
end
