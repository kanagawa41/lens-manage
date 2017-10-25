module LensInfoAnalysis extend self
  require 'nkf'

  # 「1.1-2.2」　にマッチ
  NUM_MATCH_STR = "[+-]?[0-9][+-]?[0-9]*+[\.]?[0-9]*[+-]?[0-9]*".freeze

  # 「Schneider cinegon」 にマッチ
  EN_WORDS_MATCH_STR = "([a-z]+\s*)+".freeze

  # 除外日本語系
  EX_JP = [
    "改造", "新", "古", "販売", "使捨", "年", "製", "付", "眼", "鏡", "純正",
    "前後", "型", "軽量", "説明書", "簡易", "世代", "表示", "価格", "画像", "撮",
    "解放", "機", "薦", "勧", "円", "可能", "交換", "表記", "その他", "装", "期",
    "構造", "問題", "種類", "場合", "希少", "美品", "大学", "傷", "合", "用",
    "薄", "沈", "取扱", "版"
  ].freeze
  # 除外日本語系(一致)
  EX_KN_JP = [
    "タイプ", "ニュー", "オールド", "フロント", "ミリ", "リミテッド", "メガネ", "ジャンク",
    "オススメ", "メートル", "ケース", "テレビ", "サイズ"
  ].freeze
  # 除外カメラ系
  EX_JP_LENS = [
    "最短", "無限", "三脚", "雲台"
  ].freeze
  # 除外カメラ系(一致)
  EX_KN_LENS = [
    "レンズ", "カメラ", "マウント", "キャップ", "フィルター", "フード", "ボケ", "ケラレ", "コーティング", "アダプタ"
  ].freeze
  # 除外英語系
  EX_EN = ["type", "mount", "new", "old", "for", "www", "cap", "in", "mm","g\\.a\\.", "\\.\\.\\."].freeze

  # カンマ(,)区切りの文字列からランキング付けを行う
  # e.g. レンズ,...,キャップ付,Cマウント,付き,マイクロフォーサーズ,レンズ,オススメです,レンズ,ボケ,TAYLOR,COOKE FILMO SPECIAL 1inch F1,8...
  def create_ranking(raw_words)
  	words = before_analysis raw_words
# pp raw_words
# pp "~~~~~~~~~~~~~~~~^"
# pp words

    ranking = {}
    words.split(',').each do |word|
      # 単語単位で精査
      word.split(' ').each do |s_word|
	      unless increase_match_count(words, s_word, ranking)
	      	# 該当しない文字は除去する
	      	word = word.sub(/\s?#{s_word}|#{s_word}\s?/, '')
	      end
      end

      # そのままの状態
      increase_match_count(words, word, ranking)
    end

    # 一文字のキーは削除
    ranking.each do |k, v|
    	ranking.delete(k) if k.size == 1
    end

    # キー名で昇順
    ranking = Hash[ranking.sort_by{ |_, v| -v }]

    # 空白を除去した場合と同等の文字が存在するか
    # 「pentax q」、「pentaxq」のように
		# 出現回数が高い形式を優先する
    ranking.each do |k, v|
    	search_word = k.gsub(/\s/, '')

      ranking.each do |k2, v2|
        next if k == k2
	    	if search_word == k2.gsub(/\s/, '')
	    		if ranking[k] > ranking[k2]
	          ranking[k] = ranking[k] + ranking[k2]
	          ranking.delete k2
	        else
	          ranking[k2] = ranking[k] + ranking[k2]
	          ranking.delete k
	        end

          break
        end
      end
    end

    # 一致数で降順
    Hash[*ranking.sort{|(k1, v1), (k2, v2)| v2 <=> v1 }.flatten]
  end

  private

  # 一致した文字をカウントアップする
  def increase_match_count(words, word, ranking)
    # 空白無視
    return false if !word.present? && word.strip.present?

  	word = word.strip

    # 最終文字が記号で終わっている
    # ライカスクリュー l-
    return false if word.match(/.+[-]$|^[-].+/)

    # 漢字一文字
    return false unless word.sub(/[一-龠々]/, '').present?

    # 数値のみ無視
    return false if word.match(/^#{NUM_MATCH_STR}+$/)

    match_count = words.scan(word).size

    ranking[word] = ranking.has_key?(word) ? match_count + ranking[word] : match_count

    true
	end

  # 解析前処理
  def before_analysis(word)
  	convert_word = word

    # 英数を全角から半角へ変換
    convert_word = convert_word.tr('０-９', '0-9')
    # カタカナを半角から全角へ変換
    convert_word = NKF.nkf('-wX', convert_word)
    # アルファベットと記号を半角から全角へ変換
    convert_word = NKF.nkf('-wZ0', convert_word)
    # 小文字へ変換
    convert_word = convert_word.downcase
    # 全角空白を半角へ変換
    convert_word = NKF.nkf('-wZ1', convert_word)
    # 特殊記号を空白へ変換([半角]|[全角])
    convert_word = convert_word.gsub(/[…=\/【】@\(\)●○¥"\:\*\[\]]|[．・、]/, ' ')
    # ひらがなの除去
    # ※レンズ名の呼称にひらがなは使用しないので
    convert_word = convert_word.gsub(/\p{hiragana}/, ' ')

    # 特定のワードを除外
    convert_word = exclude_all_word convert_word

    tmp_convert_words = []
    convert_word.split(',').each do |word|
      next if exclude_specific_word? word

      tmp_convert_words << word
    end

    convert_word = tmp_convert_words.join(',')

    # 複数の英単語が並んでいた場合は、一つの単語とする
    convert_word = convert_word.gsub(/((?:[a-z]+\s*){2,}+)/){"," + $1 + ","}

    # 空白の連続を一つへ
    convert_word = convert_word.gsub(/\s+/, ' ')
    # 「 ,」「, 」を除去
    convert_word = convert_word.gsub(/\s?,\s?/, ',')
    # 「,」の連続を一つへ
    convert_word = convert_word.gsub(/,+/, ',')
  end

  # 全体的な文字の除外
  def exclude_all_word(words)
    exclude_word = words

    # 日本語系
    exclude_word = exclude_word.gsub(/#{EX_JP.join('|')}/, ' ')

    # カメラ系
    exclude_word = exclude_word.gsub(/#{EX_JP_LENS.join('|')}/, ' ')

    # 28mm
    lens_info_match1 = "#{NUM_MATCH_STR}\s*m{1,2}"
    # f2
    lens_info_match2 = "f\s*#{NUM_MATCH_STR}"
    # 12cm
    lens_info_match3 = "#{NUM_MATCH_STR}\s*cm"
    exclude_word = exclude_word.gsub(/#{lens_info_match1}|#{lens_info_match2}|#{lens_info_match3}/, ' ')

    # 1974年
    exclude_word.gsub(/[0-9]+年/, ' ')
  end

  # ピンポイントの文字の除外対象か？
  def exclude_specific_word?(word)
    # 英語系
    return true if word.match /#{EX_EN.join('|')}/

    # 通常カタカナ
    return true if word.match /#{EX_KN_JP.join('|')}/

    # カメラ関係カタカナ
    return true if word.match /#{EX_KN_LENS.join('|')}/

    false
  end

end