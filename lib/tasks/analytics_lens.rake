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

    desc "Googleの結果から重要度ランキングを全て抽出する"
    task word_ranking: :environment do
      MShopInfo.select(:id, :shop_name).where(disabled: false).all.each do |m|
        `bundle exec rails analytics_lens:word_ranking[#{m.id}] RAILS_ENV=#{Rails.env}`
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
      end

      AnalyticsLensInfo.import analytics_lnes_infos.map{|r| AnalyticsLensInfo.new(r)}
      break # 全部を取得しようとしたら、Googleがレスポンスを返さなくなるため
    end
  end

  # 1.1-2.2　にマッチできる
  NUM_MATCH_STR = "[0-9][+-]?[0-9]*+[\.]?[0-9]*[+-]?[0-9]*"

  # 日本語系
  EX_JP = [
    "...", "改造", "タイプ", "おすすめ", "ほぼ", "新品", "中古", "ニュー", "オールド", "販売",
    "使い捨て", "年製", "フロント", "付き", "つき", "付け", "つけ", "眼鏡", "純正", "ミリ",
    "リミテッド", "前後", "薄型", "軽量", "メガネ付", "ジャンク", "説明書", "簡易"
  ]
  # カメラ系
  EX_JP_LENS = [
    "レンズ", "カメラ", "マウント", "キャップ", "最短", "パンケーキ", "オート"
  ]
  # 英語系
  EX_EN = ["mc", "af", "av", "dx", "type", "mount", "new", "old", "for"]

  # 除外したい文字
  def exclude_word?(word)
    # 日本語系(曖昧一致)
    EX_JP.each do |exclude_word|
      if word.include? exclude_word
        return true
      end
    end

    # カメラ系(曖昧一致)
    EX_JP_LENS.each do |exclude_word|
      if word.include? exclude_word
        return true
      end
    end

    # 英語系(完全一致)
    if EX_EN.include? word
      return true
    end

    # 特殊記号
    # f/2
    if word.match(/[…\.\=\/【】\.@\(\)]|[．＠（）・]/)
      return true
    end

    # f2、28mm、12cm
    if word.match(/#{NUM_MATCH_STR}\s*m{1,2}|f\s*#{NUM_MATCH_STR}|#{NUM_MATCH_STR}\s*cm/)
      return true
    end

    # 1974年
    if word.match(/[0-9]+年/)
      return true
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
      google_match_words = r["google_match_words"]

      ranking = {}
      google_match_words.split(',').each do |word|
        # 空白無視
        next unless word.present?

        word.gsub(/(\s|　)+/, ' ').split(' ').each do |s_word|
          # 数値のみ無視
          next if s_word.match(/^#{NUM_MATCH_STR}+$/)

          # 「64(3」のような文字が渡ることがあるため
          match_count = google_match_words.scan(/#{Regexp.escape(s_word)}/).size

          # 全角から半角へ変換
          s_word = s_word.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
          # 小文字へ変換
          s_word = s_word.downcase

          if ranking.has_key? s_word
            ranking[s_word] = match_count + ranking[s_word]
          else
            ranking[s_word] = match_count
          end
        end
      end

      # キー名で昇順
      ranking = Hash[ranking.sort_by{ |_, v| -v }]

      # 文字１が文字２に含まれている場合は、文字１の派生として扱う。
      ranking.each do |k, v|
        ranking.each do |k2, v2|
          next if k == k2

          if k2.include?(k)
            ranking[k] = ranking[k] + ranking[k2]
            ranking.delete k2
          end
        end
      end

      # 意味のない文字の除外
      ranking.each do |k, v|
        # 対象文字が小さすぎ
        if k.size == 1
          ranking.delete k
          next
        end

        # 含ませたくない文字が含まれている
        if exclude_word? k
          ranking.delete k
          next
        end
      end

      # 一致数で降順
      ranking.sort{|(k1, v1), (k2, v2)| v2 <=> v1 }

      AnalyticsLensInfo.find(r["id"]).update(ranking_words: ranking.keys)
    end
  end

end