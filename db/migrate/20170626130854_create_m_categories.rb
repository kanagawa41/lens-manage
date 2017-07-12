class CreateMCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :m_categories do |t|
      t.string :category_name, null: false
      t.boolean :is_big_category, null: false, default: false

      t.timestamps
    end
  end
end
