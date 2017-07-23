class CreateMLendsInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :m_lends_infos do |t|
      t.string :lends_name
      t.string :lends_pic_url
      t.string :stock_state
      t.integer :price
      t.references :m_shop_info, foreign_key: true

      t.timestamps
    end
  end
end
