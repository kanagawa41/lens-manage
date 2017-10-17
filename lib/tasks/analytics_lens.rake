namespace :analytics_lens do
  namespace :all do
    desc "F値、焦点距離を全て解析する"
    task lens_info: :environment do
      MShopInfo.select(:id, :shop_name).where(disabled: false).all.each do |m|
        `bundle exec rails analytics_lens:lens_info[#{m.id}] RAILS_ENV=#{Rails.env}`
      end
    end

    desc "Googleの結果から重要度ランキングを全て抽出する"
    task word_ranking: :environment do
      MShopInfo.select(:id, :shop_name).where(disabled: false).all.each do |m|
        `bundle exec rails analytics_lens:word_ranking[#{m.id}] RAILS_ENV=#{Rails.env}`
      end
    end
  end

  namespace :reset do
    desc "リセット後にGoogleの結果から重要度ランキングを全て抽出する"
    task word_ranking: :environment do
      MShopInfo.select(:id, :shop_name).where(disabled: false).all.each do |m|
        AnalyticsLensInfo.includes(:m_lens_info).joins(:m_lens_info).where("m_lens_infos.m_shop_info_id"=> m.id).update_all(ranking_words: nil)
        `bundle exec rails analytics_lens:word_ranking[#{m.id}] RAILS_ENV=#{Rails.env}`
      end
    end
  end

  desc "F値、焦点距離を解析する"
  task :lens_info, ['target_shop_id'] => :environment do |task, args|
    TaskCommon::set_log 'analytics_lens/lens_info'

    TaskSwitchLensInfo::fetch args[:target_shop_id].to_i
  end

  desc "レンズのGoogleの見解を解析する(※ショップ指定なし)"
  task lens_related_word_with_google: :environment do |task, args|
    TaskCommon::set_log 'analytics_lens/lens_related_word_with_google'

    $session = TaskCommon::get_session

    # Googleに関連性を検索しに行く
    def search_google_for_lens(search_word)
      begin
        # ”レンズ”をつけて検索結果をいい感じにする
        # レンズ Nikon ニッコール 85/2L
        $session.visit "https://www.google.co.jp/search?q=#{URI.escape("レンズ " + search_word.gsub(/レンズ|ﾚﾝｽﾞ/, ''))}"

        # 関連性と強調単語
        {related_words: $session.all(:css, "._Bmc").map{|r| r.text}, match_words: $session.all(:css, "b").map{|r| r.text}}
      rescue => e
        Rails.logger.error e.message
        return {related_words: [], match_words: []}
      end
    end

    query = <<-SQL
      SELECT mli.id, mli.lens_name
      FROM m_lens_infos as mli
      LEFT OUTER JOIN analytics_lens_infos AS ali ON ali.m_lens_info_id = mli.id
      WHERE ali.id IS NULL
      LIMIT 30
    SQL

    analytics_lnes_infos = []
    ActiveRecord::Base.connection.select_all(query).to_a.each do |lens_info|
      TaskCommon::access_sleep

      search_result = search_google_for_lens lens_info["lens_name"]

      analytics_lnes_infos << {m_lens_info_id: lens_info["id"], google_related_words: search_result[:related_words].join(','), google_match_words: search_result[:match_words].join(',')}

      AnalyticsLensInfo.import analytics_lnes_infos.map{|r| AnalyticsLensInfo.new(r)}
    end
  end

  desc "Googleの結果から重要度ランキングを抽出する"
  task :word_ranking, ['target_shop_id'] => :environment do |task, args|
    TaskCommon::set_log 'analytics_lens/word_ranking'

    shop_id = args[:target_shop_id].to_i

    query = <<-SQL
      SELECT ali.id, ali.google_match_words
      FROM m_lens_infos as mli
      INNER JOIN analytics_lens_infos AS ali ON ali.m_lens_info_id = mli.id
      WHERE ali.ranking_words IS NULL
      AND mli.m_shop_info_id = #{shop_id}
    SQL

    analytics_lens_infos = []
    ActiveRecord::Base.connection.select_all(query).to_a.each do |r|
      ranking = LensInfoAnalysis::create_ranking r["google_match_words"]

      AnalyticsLensInfo.find(r["id"]).update(ranking_words: ranking.keys.join(','))
    end
  end

end