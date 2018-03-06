class CreateLdapAttributeAssigns < ActiveRecord::Migration[5.1]
  def change
    create_table :ldap_attribute_assigns do |t|
      t.integer :service_provider_id
      t.integer :ldap_attribute_id

      t.timestamps
    end
  end
end
