require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
  # test "the truth" do
  #   assert true
  # end

  test "when send invalid data, updating should fail" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
    assert_select 'div.alert', 'The form contains4 errors'
  end

  test "successful edit with friendly forwading" do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], edit_user_url(@user)
    log_in_as(@user)
    assert_nil session[:forwarding_url]
    assert_redirected_to edit_user_url(@user)
    get edit_user_path(@user)
    name = "Foo bar"
    email = "foo@gar.com"
    patch user_path(@user), params: { user: { name: name, 
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "should only redirected to friendly forwarding" do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], edit_user_url(@user)
    log_in_as(@user)
    assert_nil session[:forwarding_url]
    assert_redirected_to edit_user_url(@user)

    delete logout_path
    log_in_as(@user)
    assert_nil session[:forwarding_url]
    assert_redirected_to user_url(@user)
  end
end
