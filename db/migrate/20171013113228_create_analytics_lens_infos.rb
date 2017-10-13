class CreateAnalyticsLensInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :analytics_lens_infos do |t|
      t.references :m_lens_info, foreign_key: true, null: false
      t.text :google_related_words, null: false, limit: 4294967295

      t.timestamps
    end
  end
end
