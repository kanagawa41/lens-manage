class CreateMLensGenres < ActiveRecord::Migration[5.1]
  def change
    create_table :m_lens_genres do |t|
      t.integer :group_no, null: false
      t.string :genre_name, null: false

      t.timestamps
    end
  end
end
