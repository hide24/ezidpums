class CreateIdProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :id_providers do |t|
      t.string :name
      t.string :entity_id
      t.text :cert
      t.text :key
      t.text :ca_cert
      t.string :ldap_connecter

      t.timestamps
    end
  end
end
