require "test_helper"

class SignIn::PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sign_in_password = sign_in_passwords(:one)
  end

  test "should get index" do
    get sign_in_passwords_url
    assert_response :success
  end

  test "should get new" do
    get new_sign_in_password_url
    assert_response :success
  end

  test "should create sign_in_password" do
    assert_difference('SignIn::Password.count') do
      post sign_in_passwords_url, params: { sign_in_password: {  } }
    end

    assert_redirected_to sign_in_password_url(SignIn::Password.last)
  end

  test "should show sign_in_password" do
    get sign_in_password_url(@sign_in_password)
    assert_response :success
  end

  test "should get edit" do
    get edit_sign_in_password_url(@sign_in_password)
    assert_response :success
  end

  test "should update sign_in_password" do
    patch sign_in_password_url(@sign_in_password), params: { sign_in_password: {  } }
    assert_redirected_to sign_in_password_url(@sign_in_password)
  end

  test "should destroy sign_in_password" do
    assert_difference('SignIn::Password.count', -1) do
      delete sign_in_password_url(@sign_in_password)
    end

    assert_redirected_to sign_in_passwords_url
  end
end
