namespace :analytics_lens do
  namespace :all do
    desc "F値、焦点距離を全て解析する"
    task lens_info: :environment do
      MShopInfo.select(:id, :shop_name).where(disabled: false).all.each do |m|
        `bundle exec rails analytics_lens:lens_info[#{m.id}] RAILS_ENV=#{Rails.env}`
      end
    end

    desc "レンズのGoogleの見解を全て解析する"
    task lens_related_word_with_google: :environment do
      MShopInfo.select(:id, :shop_name).where(disabled: false).all.each do |m|
        `bundle exec rails analytics_lens:lens_related_word_with_google[#{m.id}] RAILS_ENV=#{Rails.env}`
      end
    end
  end

  desc "F値、焦点距離を解析する"
  task :lens_info, ['target_shop_id'] => :environment do |task, args|
    TaskCommon::set_log 'analytics_lens/lens_info'

    TaskSwitchLensInfo::fetch args[:target_shop_id].to_i
  end

  desc "レンズのGoogleの見解を解析する"
  task :lens_related_word_with_google, ['target_shop_id'] => :environment do |task, args|
    TaskCommon::set_log 'analytics_lens/lens_related_word_with_google'

    $session = TaskCommon::get_session

    # Googleに関連性を検索しに行く
    def search_google_related_words_for_lens(search_word)
      begin
        # ”レンズ”をつけて検索結果をいい感じにする
        $session.visit "https://www.google.co.jp/search?q=#{URI.escape(search_word + " レンズ")}"

        $session.all("._Bmc").map{|r| r.text}
      rescue => e
        Rails.logger.error e.message
        return []
      end
    end

    shop_id = args[:target_shop_id].to_i

    query = <<-SQL
      SELECT mli.id, mli.lens_name
      FROM m_lens_infos as mli
      LEFT OUTER JOIN analytics_lens_infos AS ali ON ali.m_lens_info_id = mli.id
      WHERE ali.id IS NULL
      AND mli.m_shop_info_id = #{shop_id}
    SQL

    ActiveRecord::Base.connection.select_all(query).each_slice(10).to_a.each do |lens_info_group|
      TaskCommon::access_sleep

      analytics_lnes_infos = []
      lens_info_group.each do |lens_info|
        related_words = search_google_related_words_for_lens lens_info["lens_name"]

        analytics_lnes_infos << {m_lens_info_id: lens_info["id"], google_related_words: related_words.join(',')}
      end
      AnalyticsLensInfo.import analytics_lnes_infos.map{|r| AnalyticsLensInfo.new(r)}
    end
  end

end