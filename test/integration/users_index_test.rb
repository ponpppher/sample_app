require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    # login admin user and go index page
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2

    # confirm paginate users in index page
    # when user is not admin, should show delete links
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end

    # confirm user count, when delete non admin user
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
