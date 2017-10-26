class AddDoneFlagToAnalyticsLensInfos < ActiveRecord::Migration[5.1]
  def change
    add_column :analytics_lens_infos, :done_flag, :boolean, null: false, after: :ranking_words
  end
end
