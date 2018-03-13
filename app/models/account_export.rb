class AccountExport < ApplicationRecord
  def filename(format)
    'accounts.%s.%s' % [created_at.to_formatted_s(:number), format]
  end

  def self.dump
    account_export = self.create(raw: Account.dump(scope: :one))
    account_export.csv = self.create_csv
    account_export.xls = self.create_xls

    account_export.save
    account_export
  end

  def self.create_csv
    dump_attributes = LdapAttribute.attribute_names
    CSV.generate do |csv|
      csv << dump_attributes
      Account.all.each do |account|
        csv << dump_attributes.map{|attr| account.send(attr)}
      end
    end
  end

  def self.create_xls
    dump_attributes = LdapAttribute.attribute_names
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.name = 'accounts'
    sheet.update_row(0, *dump_attributes)
    row_index = 1
    sheet_index = 1

    Account.all.each do |account|
      sheet.update_row(row_index, *dump_attributes.map{|attr| account.send(attr)})
      row_index += 1
      if row_index > 30_000
        sheet_index += 1
        sheet = book.create_worksheet
        sheet.name = 'accounts(%s)' % sheet_index
        row_index = 1
        sheet.update_row(0, *dump_attributes)
      end
    end

    out_stream = StringIO.new
    book.write(out_stream)
    out_stream.string
  end

  def load
    AccountExport.dump
    Account.delete_all(nil, scope: :sub)
    Account.load(raw)
  end
end
