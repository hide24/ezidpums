class AccountImport < ApplicationRecord
  def self.accept(raw_data)
    account_import = self.create(raw: raw_data)
    account_import.make_internal
    account_import.save
    account_import
  end

  def data
    @data ||= Marshal.load(internal) rescue nil
  end

  def data=(new_data)
    @data = new_data
    self.internal = Marshal.dump(new_data)
  end

  def make_internal
    begin
      read_xls
      self.format = 'xls'
    rescue Ole::Storage::FormatError => e
      read_csv
      self.format = 'csv'
    end
    make_hash
    self.internal = Marshal.dump(@data)
  rescue
    errors.add(:raw, ': unknown format.')
  end

  def read_xls
    in_stream = StringIO.new(raw)
    book = Spreadsheet.open(in_stream)
    xls_data = []
    header = nil
    book.worksheets.each do |sheet|
      header ||= sheet.row(0).map{|c| c.kind_of?(Numeric)? c.to_i.to_s: c.to_s}
      sheet.each(1) do |row|
        xls_data << row.map{|c| c.kind_of?(Numeric)? c.to_i.to_s: c.to_s}
      end
    end
    @parsed_data = xls_data.unshift(header)
  end

  def read_csv
    raw_utf_8 = Kconv.toutf8(raw)
    @parsed_data = CSV.parse(raw_utf_8)
  end

  def make_hash(parsed_data = @parsed_data)
    parsed_data = parsed_data.dup
    header = parsed_data.shift
    undefined_names = header - LdapAttribute.attribute_names
    unless undefined_names.empty?
      errors.add(:raw, ': header line contains invalid attribute names(%s)' % undefined_names.inspect)
      return
    end
    begin
      @data = parsed_data.map do |account|
        Hash[header.zip(account)]
      end
    rescue
      errors.add(:row, ": header line's colnum is not match data line's colnum.")
    end
    @data
  end

  def load
    account_data = data
    AccountExport.dump
    Account.delete_all(nil, scope: :sub)
    account_data.each.with_index do |a, i|
      account = Account.new(a)
      unless account.save
        errors.add(:raw, ': line(%d) has error(%s). update is canceled.' % [i + 2, account.errors.full_messages.join(', ')])
        AccountExport.order(:created_at).last.load
        return
      end
    end
    errors.empty?
  end

  alias :do_check :make_internal
end
