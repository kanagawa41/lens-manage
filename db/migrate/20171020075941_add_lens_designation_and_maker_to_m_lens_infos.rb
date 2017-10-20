class AddLensDesignationAndMakerToMLensInfos < ActiveRecord::Migration[5.1]
  def change
    add_column :m_lens_infos, :designation, :int8, limit: 8, foreign_key: {to_table: :m_proper_nouns}, after: :tags
    add_column :m_lens_infos, :maker, :int8, limit: 8, foreign_key: {to_table: :m_proper_nouns}, after: :designation
  end
end
