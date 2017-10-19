class AddUniqOfMLensInfoIdToAnalyticsLensInfos < ActiveRecord::Migration[5.1]
  def change
    # FIXME: 一度実行してコメントアウトして実行すると通る
  	# remove_foreign_key :analytics_lens_infos, :m_lens_infos
  	# remove_index :analytics_lens_infos, :m_lens_info_id
  	add_index :analytics_lens_infos, :m_lens_info_id, unique: true
  	add_foreign_key :analytics_lens_infos, :m_lens_infos
  end
end
