class CreateItemWarehouses < ActiveRecord::Migration[5.1]
  def change
    create_table :item_warehouses do |t|
      t.text :html
      t.integer :http_status

      t.timestamps
    end

    add_reference :item_warehouses, :reserve, foreign_key: true
    add_reference :item_warehouses, :m_categories, foreign_key: true
  end
end
