class CreateCategoryPages < ActiveRecord::Migration[5.1]
  def change
    create_table :category_pages do |t|
      t.string :range
      t.boolean :complete_flag, null: false, default: false
      t.integer :m_category_id, null: false

      t.timestamps
    end
  end
end
