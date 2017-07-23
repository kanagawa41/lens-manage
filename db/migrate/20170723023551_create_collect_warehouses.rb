class CreateCollectWarehouses < ActiveRecord::Migration[5.1]
  def change
    create_table :collect_warehouses do |t|
      t.references :m_shop_info, foreign_key: true
      t.string :row_collect_text

      t.timestamps
    end
  end
end
