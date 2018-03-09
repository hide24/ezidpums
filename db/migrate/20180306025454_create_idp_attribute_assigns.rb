class CreateIdpAttributeAssigns < ActiveRecord::Migration[5.1]
  def change
    create_table :idp_attribute_assigns do |t|
      t.integer :service_provider_id
      t.integer :idp_attribute_id

      t.timestamps
    end
  end
end
