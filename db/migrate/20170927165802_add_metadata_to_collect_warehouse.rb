class AddMetadataToCollectWarehouse < ActiveRecord::Migration[5.1]
  def change
    add_reference :collect_warehouses, :m_lens_info, index: true, after: :id
    add_column :collect_warehouses, :metadata, :text, :null => true, :limit => 4294967295, after: :m_lens_info_id
    add_foreign_key :collect_warehouses, :m_lens_infos
  end
end
