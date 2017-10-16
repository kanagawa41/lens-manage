class AddGoogleMatchWordsToAnalyticsLensInfos < ActiveRecord::Migration[5.1]
  def change
    add_column :analytics_lens_infos, :google_match_words, :text, null: false, limit: 4294967295, after: :google_related_words
  end
end
