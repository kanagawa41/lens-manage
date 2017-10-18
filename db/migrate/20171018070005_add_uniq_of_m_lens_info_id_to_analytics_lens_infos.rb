class AddUniqOfMLensInfoIdToAnalyticsLensInfos < ActiveRecord::Migration[5.1]
  def change
  	add_index :analytics_lens_infos, :m_lens_info_id, unique: true
  end
end
