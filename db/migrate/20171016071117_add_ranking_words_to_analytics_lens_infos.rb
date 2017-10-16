class AddRankingWordsToAnalyticsLensInfos < ActiveRecord::Migration[5.1]
  def change
    add_column :analytics_lens_infos, :ranking_words, :text, null: true, default: nil, limit: 4294967295, after: :google_match_words
  end
end
