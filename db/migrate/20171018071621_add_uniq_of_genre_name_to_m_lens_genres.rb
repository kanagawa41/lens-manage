class AddUniqOfGenreNameToMLensGenres < ActiveRecord::Migration[5.1]
  def change
  	add_index :m_lens_genres, :genre_name, unique: true
  end
end
