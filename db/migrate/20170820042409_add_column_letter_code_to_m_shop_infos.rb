class AddColumnLetterCodeToMShopInfos < ActiveRecord::Migration[5.1]
  def change
    add_column :m_shop_infos, :letter_code, :string, :null => false, after: :shop_name
  end
end
