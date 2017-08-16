class AddColumnMLensInfos < ActiveRecord::Migration[5.1]
  def change
    add_column :m_lens_infos, :disabled, :boolean, :null => false, default: true, after: :m_shop_info_id
  end
end
