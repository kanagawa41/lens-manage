class ChangeColumnDisabledToMShopInfos < ActiveRecord::Migration[5.1]
  def change
    change_column_default :m_shop_infos, :disabled, false
  end
end
