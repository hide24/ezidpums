class CreateLdapAttributes < ActiveRecord::Migration[5.1]
  def change
    create_table :ldap_attributes do |t|
      t.integer :order
      t.string :name
      t.string :field_type
      t.boolean :enable

      t.timestamps
    end
  end
end
