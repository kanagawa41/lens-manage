class CreateMItems < ActiveRecord::Migration[5.1]
  def change
    create_table :m_items do |t|
      t.string :image_url1
      t.string :image_url2
      t.string :image_url3
      t.string :image_url4
      t.string :goods_name
      t.text :goods_description
      t.integer :price
      t.integer :m_category_id1
      t.integer :m_category_id2
      t.integer :m_category_id3
      t.integer :user_id
      t.integer :m_goods_statuse_id
      t.integer :m_brand_id
      t.integer :m_delivery_burden_id
      t.integer :m_prefecture
      t.text :options

      t.timestamps
    end
  end
end
