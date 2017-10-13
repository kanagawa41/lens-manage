class AddOldFlagToMLensInfos < ActiveRecord::Migration[5.1]
  def change
    add_column :m_lens_infos, :old_flag, :boolean, default: false, null: false, after: :disabled
  end
end
