class CreateIdpAttributes < ActiveRecord::Migration[5.1]
  def change
    create_table :idp_attributes do |t|
      t.integer :order
      t.string :name
      t.text :attribute_resolver
      t.boolean :enable, defaul: true

      t.timestamps
    end
  end
end
