class TaskSwitchLensInfo
  # Capybara初期設定
  def self.fetch(shop_id)
    $shop_id = shop_id

    MLensInfo.where(
      m_shop_info_id: $shop_id, f_num: nil, focal_length: nil
    ).all.each do |m_lens_info|
      if shop_id == 1 # レモン社
        target_1 m_lens_info
      elsif shop_id == 2 # モリッツ
        target_2 m_lens_info
      elsif shop_id == 3 # フォトベルゼ
        target_3 m_lens_info
      elsif shop_id == 4 # Foto:Mutori
        target_4 m_lens_info
      elsif shop_id == 5 # ドッピエッタトーキョー
        target_5 m_lens_info
      elsif shop_id == 6 # 大沢カメラ
        target_6 m_lens_info
      elsif shop_id == 7 # アカサカカメラ
        target_7 m_lens_info
      elsif shop_id == 8 # 喜久屋カメラ
        target_8 m_lens_info
      elsif shop_id == 9 # フラッシュバックカメラ
        target_9 m_lens_info
      elsif shop_id == 10 # 大貫カメラ
        target_10 m_lens_info
      elsif shop_id == 11 # カメラのマツバラ光機
        target_11 m_lens_info
      else
        raise "#{shop_id}(存在しない)"
      end
    end
  rescue => e
    raise "m_shop_info_idが#{$shop_id}のページ数が取得できませんでした。: #{e.message}"
  end

  private

  # 1.1-2.2　にマッチできる
  NUM_MATCH_STR = "[0-9][+-]?[0-9]*+[\.]?[0-9]*[+-]?[0-9]*"

  # レモン社
  def self.target_1(m_lens_info)
    # \d+／　、　／\d+\.?(\d+)?
    fixed_format1 m_lens_info
  end

  # モリッツ
  def self.target_2(m_lens_info)
    # \d+／　、　／\d+\.?(\d+)?
    fixed_format1 m_lens_info
  end

  # フォトベルゼ
  def self.target_3(m_lens_info)
    # \d+mm　、　F\d+\.?(\d+)?
    fixed_format2 m_lens_info
  end

  # Foto:Mutori
  def self.target_4(m_lens_info)
    # \d+mm　、　F\d+\.?(\d+)?
    fixed_format2 m_lens_info
  end

  # ドッピエッタトーキョー
  def self.target_5(m_lens_info)
    # \d+mm　、　F\d+\.?(\d+)?
    fixed_format2 m_lens_info
  end

  # 大沢カメラ
  def self.target_6(m_lens_info)
    # \d+mm　、　/\d.?(?:\d+)?
    fixed_format3 m_lens_info
  end

  # アカサカカメラ
  def self.target_7(m_lens_info)
    # \d+／　、　／\d+\.?(\d+)?
    fixed_format1 m_lens_info
  end

  # 喜久屋カメラ
  def self.target_8(m_lens_info)
    # \d+ｍｍ　、　ｆ\d.?(?:\d+)?
    fixed_format2 m_lens_info
  end

  # フラッシュバックカメラ
  def self.target_9(m_lens_info)
    # \d+ｍｍ　、　ｆ\d.?(?:\d+)?
    fixed_format2 m_lens_info
  end

  # 大貫カメラ
  def self.target_10(m_lens_info)
    # \d+／　、　／\d+\.?(\d+)?
    fixed_format1 m_lens_info
  end

  # カメラのマツバラ光機
  def self.target_11(m_lens_info)
    # \d+/　、　/\d.?(?:\d+)?
    fixed_format1 m_lens_info
  end

  private

  # 検索を掛ける前に統一にする
  def self.safe_lnes_name(lens_name)
    lens_name.gsub(/ｍｍ|MM/, 'mm').gsub(/Ｆ|ｆ/, 'f').gsub(/．/, '.').gsub(/／/, '/').gsub(/ー/, '-').tr("０-９", "0-9").downcase
  end

  # 200(focal)/10(F)
  def self.fixed_format1(m_lens_info)
    focal_length_pattern = Regexp.new("(#{NUM_MATCH_STR})\/", Regexp::IGNORECASE)
    f_num_pattern = Regexp.new("\/(#{NUM_MATCH_STR})", Regexp::IGNORECASE)

    save_selected_info(m_lens_info, focal_length_pattern, f_num_pattern)
  end

  # 200mm(focal) f10(F)
  def self.fixed_format2(m_lens_info)
    focal_length_pattern = Regexp.new("(#{NUM_MATCH_STR})mm", Regexp::IGNORECASE)
    f_num_pattern = Regexp.new("f(#{NUM_MATCH_STR})", Regexp::IGNORECASE)

    save_selected_info(m_lens_info, focal_length_pattern, f_num_pattern)
  end

  # 200mm(focal)/10(F)
  def self.fixed_format3(m_lens_info)
    focal_length_pattern = Regexp.new("(#{NUM_MATCH_STR})mm", Regexp::IGNORECASE)
    f_num_pattern = Regexp.new("\/(#{NUM_MATCH_STR})", Regexp::IGNORECASE)

    save_selected_info(m_lens_info, focal_length_pattern, f_num_pattern)
  end

  def self.save_selected_info(m_lens_info, focal_length_pattern, f_num_pattern)
    lens_name = safe_lnes_name(m_lens_info[:lens_name])

    focal_length = ""
    if md = focal_length_pattern.match(lens_name)
      focal_length = md[1]
    end

    f_num = ""
    if md = f_num_pattern.match(lens_name)
      f_num = md[1]
    end

    return if focal_length == "" || f_num == ""

    # 焦点距離に「.」は通常含まれないので、逆転している可能性がある
    if focal_length =~ /\./
      tmp_focal_length = focal_length
      tmp_f_num = f_num

      focal_length = tmp_f_num
      f_num = tmp_focal_length
    end

    m_lens_info[:focal_length] = focal_length
    m_lens_info[:f_num] = f_num

    m_lens_info.save!
  end
end