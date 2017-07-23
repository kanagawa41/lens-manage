class CreateMShopInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :m_shop_infos do |t|
      t.string :shop_name
      t.string :shop_url

      t.timestamps
    end
  end
end
