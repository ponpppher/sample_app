require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid signup information" do
    get sign_up_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'ul' do
        assert_select 'li', "Password confirmation doesn't match Password"
        assert_select 'li', "Name can't be blank"
        assert_select 'li', "Email is invalid"
        assert_select 'li', "Password is too short (minimum is 6 characters)"
    end

    assert_select 'div.alert-danger',"The form contains4 errors"
    assert_select 'form[action="/sign_up"]'
  end

  test "valid signup information" do
    get sign_up_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password" } }
    end

    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
