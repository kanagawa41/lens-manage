class CreateCategoryPages < ActiveRecord::Migration[5.1]
  def change
    create_table :category_pages do |t|
      t.string :range
      t.boolean :complete_flag, null: false, default: false

      t.timestamps
    end

    add_reference :category_pages, :m_category, foreign_key: true, after: :complete_flag
  end
end
