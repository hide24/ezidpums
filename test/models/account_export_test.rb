require 'test_helper'

class AccountExportTest < ActiveSupport::TestCase
  setup do
    @account_export = account_exports(:one)
    @account_export.load
    @expect_data = [
      ['displayName', 'mail', 'uid'],
      ['test01', 'test01@test.org', 'test01'],
      ['test02', 'test02@test.org', 'test02'],
    ]
  end

  test ".dump shuould create instance and return it." do
    return_val = nil
    assert_difference('AccountExport.count', 1) do
      return_val = AccountExport.dump
    end
    assert return_val.kind_of? AccountExport
  end

  test ".create_csv should returns CSV formatted accounts" do
    expect_csv = CSV.generate do |csv|
      @expect_data.each{|row| csv << row}
    end
    assert_equal expect_csv, AccountExport.create_csv
  end

  test ".create_xls should returns xls(Excel) formatted accounts" do
    xls_bin = AccountExport.create_xls
    in_stream = StringIO.new(xls_bin)
    book = Spreadsheet.open(in_stream)
    sheet = book.worksheet(0)
    xls_data = []
    sheet.each do |row|
      rows = []
      row.each{|col| rows << col}
      xls_data << row
    end
    assert_equal @expect_data, xls_data
  end

  test "#load should overwrite accounts from #row" do
    @account_export = account_exports(:two)
    @account_export.load
    assert_equal 1, Account.count
    @account_export = account_exports(:one)
    @account_export.load
  end

  test "#filename(format) should return 'accounts.(number_styled_datetime).(format)'." do
    @account_export.created_at = Time.new(2000,1,1,0,0,0)
    expect_name = 'accounts.20000101090000.csv'
    assert_equal expect_name, @account_export.filename('csv')
  end
end
