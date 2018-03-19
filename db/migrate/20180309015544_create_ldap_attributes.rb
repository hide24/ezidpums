class CreateLdapAttributes < ActiveRecord::Migration[5.1]
  def change
    create_table :ldap_attributes do |t|
      t.integer :order
      t.string :name
      t.integer :field_type_id
      t.boolean :enable

      t.timestamps
    end
  end
end
