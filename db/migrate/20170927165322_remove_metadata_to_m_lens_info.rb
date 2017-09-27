class RemoveMetadataToMLensInfo < ActiveRecord::Migration[5.1]
  def change
    remove_column :m_lens_infos, :metadata, :string
  end
end
