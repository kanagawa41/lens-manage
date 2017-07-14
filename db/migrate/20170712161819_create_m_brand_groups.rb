class CreateMBrandGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :m_brand_groups do |t|
      t.string :brand_group_name

      t.timestamps
    end
  end
end
