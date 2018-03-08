require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  setup do
#    @account = AlTestUtils.accounts(:one)
    @account = Account.first
  end

  test "defalut org must be exist." do
    assert @account.present?
  end

  test "userPassword shuld be encription on create." do
    row_password = 'password'
    account = Account.create(uid: 'test999', user_password: row_password, display_name: 'test999')
#    account = Account.create(uid: 'test999', user_password: row_password, cn: 'test999', sn: 'test999')
    assert_not account.user_password == row_password
  end

  test "userPassword shuld be encription on update." do
    row_password = 'password'
    @account.user_password = row_password
    @account.save
    assert_not @account.user_password == row_password
  end
end
