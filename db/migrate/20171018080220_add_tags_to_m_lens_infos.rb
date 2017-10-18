class AddTagsToMLensInfos < ActiveRecord::Migration[5.1]
  def change
    add_column :m_lens_infos, :tags, :string, default: nil, after: :focal_length
  end
end
