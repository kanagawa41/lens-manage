class RemoveMshopIdAnDrowCollectTextToCollectWarehouse < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :collect_warehouses, :m_shop_infos
    remove_reference :collect_warehouses, :m_shop_info, index: true
    remove_column :collect_warehouses, :row_collect_text
  end

  def down
    add_reference :collect_warehouses, :m_shop_info, index: true
    add_foreign_key :collect_warehouses, :m_shop_infos
    add_column :collect_warehouses, :row_collect_text, :string
  end
end
