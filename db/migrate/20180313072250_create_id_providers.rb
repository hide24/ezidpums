class CreateIdProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :id_providers do |t|
      t.string :name
      t.string :entity_id
      t.string :host_name
      t.string :scope
      t.text :cert
      t.text :key
      t.text :ca_cert

      t.timestamps
    end
  end
end
