class CreateServiceProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :service_providers do |t|
      t.string :name
      t.string :entity_id
      t.text :certification
      t.boolean :enable, default: true

      t.timestamps
    end
  end
end
