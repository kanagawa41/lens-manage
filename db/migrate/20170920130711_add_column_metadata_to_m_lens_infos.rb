class AddColumnMetadataToMLensInfos < ActiveRecord::Migration[5.1]
  def change
    add_column :m_lens_infos, :metadata, :text, :null => true, :limit => 4294967295, after: :disabled
  end
end
