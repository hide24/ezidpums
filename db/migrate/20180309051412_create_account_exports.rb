class CreateAccountExports < ActiveRecord::Migration[5.1]
  def change
    create_table :account_exports do |t|
      t.binary :raw, limit: 10.megabyte
      t.binary :csv, limit: 10.megabyte
      t.binary :xls, limit: 10.megabyte

      t.timestamps
    end
  end
end
