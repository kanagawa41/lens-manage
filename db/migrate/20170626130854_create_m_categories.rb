class CreateMCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :m_categories do |t|
      t.string :category_name

      t.timestamps
    end
  end
end
