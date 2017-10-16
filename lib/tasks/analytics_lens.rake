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
    def search_google_for_lens(search_word)
      begin
        # ”レンズ”をつけて検索結果をいい感じにする
        $session.visit "https://www.google.co.jp/search?q=#{URI.escape(search_word + " レンズ")}"

        # 関連性と強調単語
        {related_words: $session.all(:css, "._Bmc").map{|r| r.text}, match_words: $session.all(:css, "b").map{|r| r.text}}
      rescue => e
        Rails.logger.error e.message
        return {related_words: [], match_words: []}
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

    ActiveRecord::Base.connection.select_all(query).each_slice(30).to_a.each do |lens_info_group|
      analytics_lnes_infos = []
      lens_info_group.each do |lens_info|
        TaskCommon::access_sleep
        search_result = search_google_for_lens lens_info["lens_name"]

        analytics_lnes_infos << {m_lens_info_id: lens_info["id"], google_related_words: search_result[:related_words].join(','), google_match_words: search_result[:match_words].join(',')}
      break # 全部を取得しようとしたら、Googleがレスポンスを返さなくなるため
      end

      AnalyticsLensInfo.import analytics_lnes_infos.map{|r| AnalyticsLensInfo.new(r)}
      break # 全部を取得しようとしたら、Googleがレスポンスを返さなくなるため
    end
  end
end