class TaskSwitchPageNum
  # Capybara初期設定
  def self.fetch(shop_id)
    $shop_id = shop_id

    collect_targets = CollectTarget.where(m_shop_info_id: $shop_id).all
    if shop_id == 1 # レモン社
      target_1 collect_targets
    elsif shop_id == 3 # フォトベルゼ
      target_3 collect_targets
    elsif shop_id == 9 # フラッシュバックカメラ
      target_9 collect_targets
    elsif shop_id == 10 # 大貫カメラ
      target_10 collect_targets
    elsif shop_id == 14 # KING-2
      target_14 collect_targets
    else
      raise "#{shop_id}(存在しない)"
    end
  rescue => e
    raise "m_shop_info_idが#{$shop_id}のページ数が取得できませんでした。: #{e.message}"
  end

  private

  # レモン社
  def self.target_1(collect_targets)
    page_pattern = Regexp.new("p=(\\d+)")

    session = TaskCommon::get_session

    collect_targets.each do |collect_target|
      # 対象URLに遷移する
      session.visit collect_target.list_url.gsub(/\[\$page\]/, '1')

      # 全てのアンカーを取得する 
      session.all(:css, '.navipage_ .navipage_last_ a').each do |anchor|
        if anchor[:href] =~ page_pattern
          collect_target.start_page_num = 1
          collect_target.end_page_num = $1
        else
          raise "#{$shop_id}"
        end
      end

      collect_target.save!
    end
  end

  # フォトベルゼ
  def self.target_3(collect_targets)
    page_pattern = Regexp.new("p=(\\d+)")

    session = TaskCommon::get_session

    collect_targets.each do |collect_target|
      collect_target.start_page_num = 1
      collect_target.end_page_num = 50

      # 過去のページは情報が古すぎるため適当なページで検索を止めている。
      #
      # # 対象URLに遷移する
      # session.visit collect_target.list_url.gsub(/\[\$page\]/, '1')

      # # 全てのアンカーを取得する 
      # session.all(:css, '.pager .paging-last a').each do |anchor|
      #   if anchor[:href] =~ page_pattern
      #     collect_target.start_page_num = 1
      #     collect_target.end_page_num = $1
      #   else
      #     raise "#{$shop_id}"
      #   end
      # end

      collect_target.save!
    end
  end

  # フラッシュバックカメラ
  def self.target_9(collect_targets)
    $page_pattern = Regexp.new("page-(\\d+)")
    $continue_page_pattern = Regexp.new("...")
    $save_count = 0

    $session = TaskCommon::get_session

    # 指定回数を超えた場合は無限ループに陥ったと判定し例外を投げる
    def self.count_up
      raise "#{$target_url} で無限ループに陥った可能性があります。" if ($save_count += 1) >= 30
    end

    def self.search_page(next_page)
      count_up
      sleep [*2..5].sample # アクセスタイミングを分散させる

      # 対象URLに遷移する
      $session.visit $target_url.gsub(/\[\$page\]/, next_page.to_s)

      last_page = 1
      # 全てのアンカーを取得する 
      $session.all(:css, '.pagination a[name="pagination"]').each do |anchor|
        last_page = $1 if anchor[:href] =~ $page_pattern

        # ページがまだ続く場合
        if anchor.text =~ $continue_page_pattern
          # 次のページ遷移した際に「...」が前後に出現する場合がある
          if anchor[:href] =~ $page_pattern && $1.to_i > next_page.to_i
            last_page = search_page $1
          end
        end
      end

      return last_page
    end

    collect_targets.each do |collect_target|
      $target_url = collect_target.list_url
      last_page = search_page(collect_target.start_page_num)

      collect_target.start_page_num = 1
      collect_target.end_page_num = last_page
      collect_target.save!

      $save_count = 0
    end
  end

  # 大貫カメラ
  def self.target_10(collect_targets)
    $page_pattern = Regexp.new("page=(\\d+)")
    $continue_page_pattern = Regexp.new("...")
    $save_count = 0

    $session = TaskCommon::get_session

    # 指定回数を超えた場合は無限ループに陥ったと判定し例外を投げる
    def self.count_up
      raise "#{$target_url} で無限ループに陥った可能性があります。" if ($save_count += 1) >= 30
    end

    def self.search_page(next_page)
      count_up
      sleep [*2..5].sample # アクセスタイミングを分散させる

      # 対象URLに遷移する
      $session.visit $target_url.gsub(/\[\$page\]/, next_page.to_s)

      last_page = 1
      # 全てのアンカーを取得する 
      $session.all(:css, '#productsListingListingBottomLinks a').each do |anchor|
        last_page = $1 if anchor[:href] =~ $page_pattern

        # ページがまだ続く場合
        if anchor.text =~ $continue_page_pattern
          # 次のページ遷移した際に「...」が前後に出現する場合がある
          if anchor[:href] =~ $page_pattern && $1.to_i > next_page.to_i
            last_page = search_page $1
          end
        end
      end

      return last_page
    end

    collect_targets.each do |collect_target|
      $target_url = collect_target.list_url
      last_page = search_page(collect_target.start_page_num)

      collect_target.start_page_num = 1
      collect_target.end_page_num = last_page
      collect_target.save!

      $save_count = 0
    end
  end

  # KING-2
  def self.target_14(collect_targets)
    $continue_page_pattern = Regexp.new("次へ")
    $save_count = 0

    $session = TaskCommon::get_session

    # 指定回数を超えた場合は無限ループに陥ったと判定し例外を投げる
    def self.count_up
      raise "#{$target_url} で無限ループに陥った可能性があります。" if ($save_count += 1) >= 30
    end

    def self.search_page(next_page)
      count_up
      sleep [*2..5].sample # アクセスタイミングを分散させる

      # 対象URLに遷移する
      $session.visit $target_url.gsub(/\[\$page\]/, next_page.to_s)

      pages = []
      next_page_flag = false
      # 全てのアンカーを取得する
      $session.all(:css, '#page_navi_top .navi a').each do |anchor|
        # ページがまだ続く場合
        if anchor.text =~ $continue_page_pattern
          next_page_flag = true
        elsif anchor.text =~ /\d+/
          pages << anchor.text.to_i
        end
      end

      last_page = 1
      if next_page_flag
        last_page = search_page pages.sort.last
      else
        last_page = pages.sort.last
      end

      # 選択しているページはアンカーではなくなるため
      if next_page > last_page
        last_page = next_page
      end

      return last_page
    end

    collect_targets.each do |collect_target|
      $target_url = collect_target.list_url
      last_page = search_page(collect_target.start_page_num)

      collect_target.start_page_num = 1
      collect_target.end_page_num = last_page
      collect_target.save!

      $save_count = 0
    end
  end

  private
    def self.set_all_one_page(collect_targets)
      collect_targets.each do |collect_target|
        collect_target.start_page_num = 1
        collect_target.end_page_num = 1

        collect_target.save!
      end
    end
end