require 'test_helper'

class AccountImportTest < ActiveSupport::TestCase
  setup do
    @account_import = account_imports(:one)
    @account_data = [
      ['uid', 'displayName', 'mail'],
      ['1001', 'user1', 'user1@test.org'],
      ['1002', 'user2', 'user2@test.org'],
      ['1003', 'user3', 'user3@test.org'],
      ['2001', '日本語1', 'user1@test.org'],
      ['2002', '日本語2', 'user2@test.org'],
      ['2003', '日本語3', 'user3@test.org'],
    ]
    @account_csv =<<-EOC
"uid","displayName","mail"
"1001","user1","user1@test.org"
"1002","user2","user2@test.org"
"1003","user3","user3@test.org"
"2001","日本語1","user1@test.org"
"2002","日本語2","user2@test.org"
"2003","日本語3","user3@test.org"
    EOC
    @xls_filename = File.join(File.dirname(__FILE__), '../bin_data/account_import_test.xls')
    @account_hash = [
      {'uid' => '1001', 'displayName' => 'user1', "mail" => 'user1@test.org'},
      {'uid' => '1002', 'displayName' => 'user2', "mail" => 'user2@test.org'},
      {'uid' => '1003', 'displayName' => 'user3', "mail" => 'user3@test.org'},
      {'uid' => '2001', 'displayName' => '日本語1', "mail" => 'user1@test.org'},
      {'uid' => '2002', 'displayName' => '日本語2', "mail" => 'user2@test.org'},
      {'uid' => '2003', 'displayName' => '日本語3', "mail" => 'user3@test.org'},
    ]
  end

  test ".accept should creates new instanse and returns it." do
    assert_difference('AccountImport.count', 1) do
      @return_val = AccountImport.accept(@account_csv)
    end
    assert @return_val.kind_of?(AccountImport)
  end

  test "when intarnal is not xls format, #read_xls should raise Ole::Storage::FormatError" do
    @account_import.raw = 'plain text'
    assert_raises Ole::Storage::FormatError do
      @account_import.read_xls
    end
  end

  test "#read_xls should return Array of account_data" do
    @account_import.raw = File.read(@xls_filename)
    assert_equal @account_data, @account_import.read_xls
  end

  test "#read_csv should return Array of account_data" do
    @account_import.raw = @account_csv
    assert_equal @account_data, @account_import.read_csv
  end

  test "#make_hash should return Hash of account_data" do
    assert_equal @account_hash, @account_import.make_hash(@account_data)
  end

  test "#make_internal should set Hash of account_data to internal.(csv.UTF-8)" do
    @account_import.raw = @account_csv
    @account_import.make_internal
    assert_equal @account_hash, Marshal.load(@account_import.internal.force_encoding('utf-8'))
  end

  test "#make_internal should set Hash of account_data to internal.(csv.SHIFT_JIS)" do
    @account_import.raw = @account_csv.encode('shift_jis')
    @account_import.make_internal
    assert_equal @account_hash, Marshal.load(@account_import.internal.force_encoding('utf-8'))
  end

  test "#make_internal should set Hash of account_data to internal.(xls)" do
    @account_import.raw = File.read(@xls_filename)
    @account_import.make_internal
    assert_equal @account_hash, Marshal.load(@account_import.internal.force_encoding('utf-8'))
  end

  test "#load should delete all accounts form LDAP, and create new accounts from @data." do
    @account_import.raw = @account_csv
    @account_import.make_internal
    @account_import.load
    assert_equal 6, Account.count
  end
end
