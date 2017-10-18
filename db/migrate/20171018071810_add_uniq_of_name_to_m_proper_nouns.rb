class AddUniqOfNameToMProperNouns < ActiveRecord::Migration[5.1]
  def change
		add_index :m_proper_nouns, [:m_lens_genre_id, :name_jp], unique: true, name: 'name_uniq_index'
  end
end
