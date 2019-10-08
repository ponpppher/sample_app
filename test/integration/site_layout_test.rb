require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end

  test "layout links when user is logout" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path, count: 2
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", login_path

    get about_path
    assert_select "title", full_title('About')

    get contact_path
    assert_select "title", full_title('Contact')

    get login_path
    assert_select "title", full_title('Log in')

    get sign_up_path
    assert_select "title", full_title('Sign up')
  end

  test "layout links when user is logged in" do
    log_in_as(@user)
    follow_redirect!
    assert_template 'users/show'

    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path, count: 2
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", user_path
    assert_select "a[href=?]", edit_user_path

    assert_select "a[href=?]", logout_path
  end
end
