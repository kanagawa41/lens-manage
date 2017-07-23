namespace :page do
  desc "ページ情報を操作する"
  require 'capybara/poltergeist'
  task fetch: :environment do
    # ログ設定
    log_name = "page-fetch"
    Rails.logger = Logger.new("log/#{log_name}.log", 'daily')

    # 最大検索範囲数
    MAX_RANGE_SEARCH_NUM = 3

    # アイテムドメイン検出用
    mercari_item_domain = Regexp.new("^#{Rails.application.config.urls['mercari_item_domain']}" +
      "m(\\d+)/")

    CATEGORY_BASE_DOMAIN = Rails.application.config.urls['mercari_category_list_domain']

    session = TaskCommon::get_session

    set_condition_m_category = MCategory.select("m_categories.id, category_pages.id as page_id, category_pages.range").
      joins(:category_pages).where("category_pages.complete_flag"=> false).
      where("m_categories.is_big_category"=> true)

    range_search_num = 0
    set_condition_m_category.all.each do |m_category|
      ranges = m_category.range.split(':')
      m_category_id = m_category.id

      Range.new(ranges[0].to_i, ranges[1].to_i).to_a.each do |num|
        sleep [*2..5].sample # アクセスタイミングを分散させる
        session.visit "#{CATEGORY_BASE_DOMAIN}#{m_category_id}/?page=#{num}"

        item_ids = []
        # 全てのアンカーを取得する 
        # href="https://item.mercari.com/jp/m48141250656/"
        session.all(:css, 'a').each do |anchor|
          href = anchor[:href]
          if href =~ mercari_item_domain
            item_ids << href.match(mercari_item_domain)[1]
          end
        end

        exist_items = MItem.select(:id).where(id: item_ids).all.map{|record| record[:id]}

        items = []
        warehoses = []
        item_ids.each do |item_id|
          unless exist_items.include? item_id
            items << MItem.new(id: item_id)
            warehoses << HtmlWarehouse.new(item_id: item_id)
          end
        end

        if items.count
          MItem.import items 
          HtmlWarehouse.import warehoses
        end
      end

      CategoryPage.where(id: m_category.page_id).update_all(complete_flag: true)
  
      break if MAX_RANGE_SEARCH_NUM == (range_search_num += 1)
    end
  end

  task reset: :environment do
    # ログ設定
    log_name = "page-reset"
    Rails.logger = Logger.new("log/#{log_name}.log", 'daily')

    CategoryPage.update_all(complete_flag: false)
  end
end
