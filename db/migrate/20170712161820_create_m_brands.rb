class CreateMBrands < ActiveRecord::Migration[5.1]
  def change
    create_table :m_brands do |t|
      t.string :brand_name
      t.integer :brand_group_id

      t.timestamps
    end
  end
end
