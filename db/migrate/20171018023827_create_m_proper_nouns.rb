class CreateMProperNouns < ActiveRecord::Migration[5.1]
  def change
    create_table :m_proper_nouns do |t|
      t.references :m_lens_genre, foreign_key: true, null: false
      t.string :name_jp, null: false
      t.string :name_en
      t.text :relate_name

      t.timestamps
    end
  end
end
