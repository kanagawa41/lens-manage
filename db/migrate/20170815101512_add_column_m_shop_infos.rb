class AddColumnMShopInfos < ActiveRecord::Migration[5.1]
  def change
    add_column :m_shop_infos, :disabled, :boolean, :null => false, default: true, after: :shop_url
  end
end
