class CreateAccountImports < ActiveRecord::Migration[5.1]
  def change
    create_table :account_imports do |t|
      t.binary :raw, limit: 10.megabyte
      t.string :format
      t.binary :internal, limit: 10.megabyte

      t.timestamps
    end
  end
end
