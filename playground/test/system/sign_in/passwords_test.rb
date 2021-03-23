require "application_system_test_case"

class SignIn::PasswordsTest < ApplicationSystemTestCase
  setup do
    @sign_in_password = sign_in_passwords(:one)
  end

  test "visiting the index" do
    visit sign_in_passwords_url
    assert_selector "h1", text: "Sign In/Passwords"
  end

  test "creating a Password" do
    visit sign_in_passwords_url
    click_on "New Sign In/Password"

    click_on "Create Password"

    assert_text "Password was successfully created"
    click_on "Back"
  end

  test "updating a Password" do
    visit sign_in_passwords_url
    click_on "Edit", match: :first

    click_on "Update Password"

    assert_text "Password was successfully updated"
    click_on "Back"
  end

  test "destroying a Password" do
    visit sign_in_passwords_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Password was successfully destroyed"
  end
end
