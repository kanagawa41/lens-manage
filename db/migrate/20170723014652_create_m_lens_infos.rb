class CreateMLensInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :m_lens_infos do |t|
      t.string :lens_name, null: false
      t.string :lens_pic_url
      t.string :lens_info_url
      t.string :stock_state
      t.integer :price
      t.references :m_shop_info, foreign_key: true

      t.timestamps
    end
  end
end
