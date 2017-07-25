class TaskSwitchPageInfo
  def self.switch(shop_id)
    $shop_id = shop_id
    if shop_id == 1 # レモン社
      target_1
    elsif shop_id == 999
      # コピー用
    else
      raise "#{shop_id}"
    end
  rescue => e
    raise "m_shop_info_idが#{e.message}のページ情報が取得できませんでした。"
  end

  private

  # レモン社
  def self.target_1
    info_page_pattern = Regexp.new("/shop\/g\/.+/")
    avarable_stock_pattern = Regexp.new("在庫状況：○")
    
    collect_targets = CollectTarget.select(:id, :list_url, :start_page_num, :end_page_num).where(m_shop_info_id: $shop_id).all

    session = TaskCommon::get_session

    success_num = 0
    fail_num = 0
    collect_targets.each do |collect_target|
      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|
        next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

        # 対象URLに遷移する
        session.visit collect_target.list_url.gsub(/\[\$page\]/, num.to_s)

        # FIXME: HTTPステータスで判断したい
        # raise "#{shop_id}-#{num}" if session.page.status_code != 200

        # レンズ情報を取得する
        session.all(:css, '.autopagerize_page_element .StyleT_Item_').each do |article|
          begin
            lends_info = {
              lends_name: nil,
              lends_pic_url: nil,
              stock_state: nil,
              price: nil,
              m_shop_info_id: $shop_id,
            }

            lends_info[:lends_name] = article.find(:css, '.name1_').text.gsub(/\r|\n|\t/, ' ').strip
            article.all(:css, 'a').each do |info_anchor|
              lends_info[:lends_pic_url] = info_anchor[:href] if info_page_pattern.match(info_anchor[:href])
            end
            lends_info[:stock_state] = avarable_stock_pattern.match(article.find(:css, '.zaiko_').text).present?
            lends_info[:price] = article.find(:css, '.price_').text.gsub(/\r|\n|\t|￥|\\|,/, '').strip

            # upsert
            if m_lends_info = MLendsInfo.where(lends_pic_url: lends_info[:lends_pic_url]).first
              m_lends_info.attributes = lends_info
            else
              m_lends_info = MLendsInfo.new(lends_info)
            end

            m_lends_info.save!

            success_num += 1
          rescue => e
            fail_num += 1
          end
        end
      end
    end

    CollectResult.new(m_shop_info_id: $shop_id, success_num: success_num, fail_num: fail_num).save!
  end

  
end