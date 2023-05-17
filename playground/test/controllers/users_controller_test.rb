# frozen_string_literal: true

require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get new" do
    get sign_up_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post sign_up_url, params: { user: { name: @user.name } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end
end
