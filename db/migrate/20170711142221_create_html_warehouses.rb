class CreateHtmlWarehouses < ActiveRecord::Migration[5.1]
  def change
    create_table :html_warehouses do |t|
      t.string :item_id, null: false
      t.text :html, null: false
      t.integer :http_status, null: false

      t.timestamps
    end
  end
end
