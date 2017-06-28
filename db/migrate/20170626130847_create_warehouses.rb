class CreateWarehouses < ActiveRecord::Migration[5.1]
  def change
    create_table :warehouses do |t|
      t.text :html
      t.integer :http_status

      t.timestamps
    end

    add_reference :warehouses, :reserve, foreign_key: true
  end
end
