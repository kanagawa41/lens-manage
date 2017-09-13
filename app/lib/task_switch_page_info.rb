class TaskSwitchPageInfo
  def self.fetch(shop_id)
    collect_targets = CollectTarget.select(:id, :list_url, :start_page_num, :end_page_num).where(m_shop_info_id: shop_id).all

    $shop_id = shop_id
    if shop_id == 1 # レモン社
      target_1 collect_targets
    elsif shop_id == 2 # モリッツ
      target_2 collect_targets
    elsif shop_id == 3 # フォトベルゼ
      target_3 collect_targets
    elsif shop_id == 4 # Foto:Mutori
      target_4 collect_targets
    elsif shop_id == 5 # ドッピエッタトーキョー
      target_5 collect_targets
    elsif shop_id == 6 # 大沢カメラ
      target_6 collect_targets
    else
      raise "#{shop_id}"
    end
  rescue => e
    raise "m_shop_info_idが#{$shop_id}のページ数が取得できませんでした。: #{e.message}"
  end

  private

  # レモン社
  def self.target_1(collect_targets)
    info_page_pattern = Regexp.new("/shop\/g\/.+/")
    avarable_stock_pattern = Regexp.new("在庫状況：○")

    session = TaskCommon::get_session

    success_num = 0
    fail_num = 0
    collect_targets.each do |collect_target|
      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|
        next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

        sleep [*2..5].sample # アクセスタイミングを分散させる

        # 対象URLに遷移する
        session.visit collect_target.list_url.gsub(/\[\$page\]/, num.to_s)

        # FIXME: HTTPステータスで判断したい
        # raise "#{shop_id}-#{num}" if session.page.status_code != 200

        # レンズ情報を取得する
        session.all(:css, '.autopagerize_page_element .StyleT_Item_').each do |article|
          begin
            lens_info = {
              lens_name: nil,
              lens_info_url: nil,
              lens_pic_url: nil,
              stock_state: nil,
              price: 0,
              m_shop_info_id: $shop_id,
            }

            lens_info[:lens_name] = article.find(:css, '.name1_').text.gsub(/\r|\n|\t/, ' ').strip
            article.all(:css, 'a').each do |info_anchor|
              lens_info[:lens_info_url] = info_anchor[:href] if info_page_pattern.match(info_anchor[:href])
            end
            lens_info[:lens_pic_url] = article.find(:css, '.img_ img')[:src].strip
            lens_info[:stock_state] = avarable_stock_pattern.match(article.find(:css, '.zaiko_').text).present?
            lens_info[:price] = article.find(:css, '.price_').text.gsub(/\r|\n|\t|¥|￥|\\|,/, '').strip

            # upsert
            if m_lens_info = MLensInfo.where(lens_info_url: lens_info[:lens_info_url], m_shop_info_id: $shop_id).first
              m_lens_info.attributes = lens_info
            else
              m_lens_info = MLensInfo.new(lens_info)
            end

            m_lens_info.save!

            success_num += 1
          rescue => e
            # pp e.message
            fail_num += 1
          end
        end
      end
    end

    CollectResult.new(m_shop_info_id: $shop_id, success_num: success_num, fail_num: fail_num).save!
  end

  # モリッツ
  def self.target_2(collect_targets)
    session = TaskCommon::get_session
    info_page_pattern = Regexp.new("/shop\/g\/.+/")
    avarable_stock_pattern = Regexp.new("売り切れ")

    success_num = 0
    fail_num = 0
    collect_targets.each do |collect_target|
      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|
        next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

        sleep [*2..5].sample # アクセスタイミングを分散させる

        # 対象URLに遷移する
        session.visit collect_target.list_url

        # レンズ情報を取得する
        session.all(:css, 'tr[bgcolor="#ffffcc"]').each do |article|

          begin
            lens_info = {
              lens_name: nil,
              lens_info_url: nil,
              lens_pic_url: nil,
              stock_state: nil,
              price: 0,
              m_shop_info_id: $shop_id,
            }

            lens_info[:lens_name] = article.all(:css, 'font[size="+1"]')[0].text.gsub(/\r|\n|\t/, ' ').strip
            lens_info[:lens_info_url] = collect_target.list_url
            lens_info[:lens_pic_url] = article.all(:css, 'td[width="15%"] img')[0][:src].strip
            state_or_price = article.all(:css, 'td[width="25%"] b')[0].text
            lens_info[:stock_state] = !avarable_stock_pattern.match(state_or_price).present?
            lens_info[:price] = lens_info[:stock_state] ? state_or_price.gsub(/\r|\n|\t|¥|￥|\\|,/, '').strip : nil

            # upsert
            if m_lens_info = MLensInfo.where(lens_name: lens_info[:lens_name], m_shop_info_id: $shop_id).first
              m_lens_info.attributes = lens_info
            else
              m_lens_info = MLensInfo.new(lens_info)
            end

            m_lens_info.save!

            success_num += 1
          rescue => e
            # pp e.message
            fail_num += 1
          end
        end
      end
    end

    CollectResult.new(m_shop_info_id: $shop_id, success_num: success_num, fail_num: fail_num).save!
  end

  # フォトベルゼ
  def self.target_3(collect_targets)
    info_page_pattern = Regexp.new("/archives\/\\d+.html")
    price_pattern = Regexp.new("商品価格：￥(\\d+)-")
    sold_out_pattern = Regexp.new("SOLD OUT")

    session = TaskCommon::get_session

    success_num = 0
    fail_num = 0
    collect_targets.each do |collect_target|
      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|
        next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

        sleep [*2..5].sample # アクセスタイミングを分散させる

        # 対象URLに遷移する
        session.visit collect_target.list_url.gsub(/\[\$page\]/, num.to_s)

        # レンズ情報を取得する
        session.all(:css, '.article-inner').each do |article|
          begin
            lens_info = {
              lens_name: nil,
              lens_info_url: nil,
              lens_pic_url: nil,
              stock_state: nil,
              price: 0,
              m_shop_info_id: $shop_id,
            }

            lens_info[:lens_name] = article.find(:css, '.article-title a').text.gsub(/\r|\n|\t/, ' ').strip
            article.all(:css, '.article-first-image a').each do |info_anchor|
              lens_info[:lens_info_url] = info_anchor[:href] if info_page_pattern.match(info_anchor[:href])
            end
            lens_info[:lens_pic_url] = article.find(:css, '.article-first-image img')[:src].strip
            lens_infos = article.find(:css, '.article-body-inner').text
            if md = lens_infos.gsub(/,/, '').match(price_pattern) # 価格
              lens_info[:price] = md[1].gsub(/\r|\n|\t|¥|￥|\\|,/, '').strip
              lens_info[:stock_state] = 1
            elsif lens_infos.match(sold_out_pattern) # 売り切れ
              lens_info[:price] = nil
              lens_info[:stock_state] = 0
            else
              lens_info[:price] = nil
              lens_info[:stock_state] = nil
            end
             
            # upsert
            if m_lens_info = MLensInfo.where(lens_info_url: lens_info[:lens_info_url], m_shop_info_id: $shop_id).first
              m_lens_info.attributes = lens_info
            else
              m_lens_info = MLensInfo.new(lens_info)
            end

            m_lens_info.save!

            success_num += 1
          rescue => e
            pp e.message
            fail_num += 1
          end
        end
      end
    end

    CollectResult.new(m_shop_info_id: $shop_id, success_num: success_num, fail_num: fail_num).save!
  end

  # Foto:Mutori
  def self.target_4(collect_targets)
    info_page_pattern = Regexp.new("/blog/\\?p=\\d+")
    avarable_stock_pattern = Regexp.new("SOLD")

    session = TaskCommon::get_session

    success_num = 0
    fail_num = 0
    collect_targets.each do |collect_target|
      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|
        next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

        sleep [*2..5].sample # アクセスタイミングを分散させる

        # 対象URLに遷移する
        session.visit collect_target.list_url

        # レンズ情報を取得する
        session.all(:css, '#post-area .post').each do |article|
          begin
            lens_info = {
              lens_name: nil,
              lens_info_url: nil,
              lens_pic_url: nil,
              stock_state: nil,
              price: 0,
              m_shop_info_id: $shop_id,
            }

            lens_info[:lens_name] = article.find(:css, '.gridly-copy h2 a').text.gsub(/\r|\n|\t/, ' ').strip
            article.all(:css, '.gridly-copy h2 a').each do |info_anchor|
              lens_info[:lens_info_url] = info_anchor[:href] if info_page_pattern.match(info_anchor[:href])
            end
            lens_info[:lens_pic_url] = article.find(:css, '.gridly-image img')[:src].strip
            lens_info[:stock_state] = !avarable_stock_pattern.match(article.find(:css, '.gridly-category').text).present?
            lens_info[:price] = nil # 記載していない

            # upsert
            if m_lens_info = MLensInfo.where(lens_info_url: lens_info[:lens_info_url], m_shop_info_id: $shop_id).first
              m_lens_info.attributes = lens_info
            else
              m_lens_info = MLensInfo.new(lens_info)
            end

            m_lens_info.save!

            success_num += 1
          rescue => e
            # pp e.message
            fail_num += 1
          end
        end
      end
    end

    CollectResult.new(m_shop_info_id: $shop_id, success_num: success_num, fail_num: fail_num).save!
  end

  # ドッピエッタトーキョー
  def self.target_5(collect_targets)
    # 無限ループに陥る可能性があるため
    safe_count = 30

    lens_name_pattern = Regexp.new("<a.+?>(.+?)</a>")
    price_pattern = Regexp.new("¥(\\d+)")
    avarable_stock_pattern = Regexp.new("Sold out")

    session = TaskCommon::get_session

    success_num = 0
    fail_num = 0
    collect_targets_arr = collect_targets.map{|collect_target| collect_target.attributes}
    collect_targets_arr.each do |collect_target|
      next unless collect_target["start_page_num"].present? && collect_target["end_page_num"].present?

      sleep [*2..5].sample # アクセスタイミングを分散させる

      # 対象URLに遷移する
      session.visit collect_target["list_url"]

      # 効かない
      # # 画面をスクロールする
      # session.execute_script('window.scroll(0,10000);')
      begin
        safe_count -= 1
        next_href = session.find(:css, '.pager-button a')[:href]
        collect_targets_arr << {"list_url"=> next_href, "start_page_num"=> 1, "end_page_num"=> 1} if !next_href.match(/\#$/) && safe_count > 0
      rescue => e
        pp "#{collect_target["list_url"]}のページ移動が失敗した。: #{e.message}"
        # 最終ページの場合
      end

      # FIXME: 情報を取得できない。要素が作成されている感じはする。だけど取得できていない。
      # レンズ情報を取得する
      session.all(:css, '.product-list .product-block').each do |article|
        begin
          lens_info = {
            lens_name: nil,
            lens_info_url: nil,
            lens_pic_url: nil,
            stock_state: nil,
            price: 0,
            m_shop_info_id: $shop_id,
          }
          # lens_info[:lens_name] = article.find(:css, '.upper a').text.gsub(/\r|\n|\t/, ' ').strip
          lens_info[:lens_name] = article.find(:css, 'div.upper')['innerHTML'].match(lens_name_pattern)[1]
          lens_info[:lens_info_url] = article.find(:css, 'a.image-inner')[:href]
          lens_info[:lens_pic_url] = article.find(:css, 'a.image-inner img')[:src].strip
          # lens_info[:stock_state] = avarable_stock_pattern.match(article.find(:css, '.caption.lower a').text).present?
          lens_info[:stock_state] = !avarable_stock_pattern.match(article.find(:css, 'div.lower')['innerHTML']).present?
          # if md = article.find(:css, 'span').text.gsub(/,/, '').match(price_pattern) # 価格
          #   lens_info[:price] = md[1].gsub(/\r|\n|\t|¥|￥|\\|,/, '').strip
          # end
          lens_info[:price] = article.find(:css, '.lower').text.gsub(/,/, '').match(price_pattern)[1].gsub(/\r|\n|\t|¥|￥|\\|,/, '').strip

          # upsert
          if m_lens_info = MLensInfo.where(lens_info_url: lens_info[:lens_info_url], m_shop_info_id: $shop_id).first
            m_lens_info.attributes = lens_info
          else
            m_lens_info = MLensInfo.new(lens_info)
          end

          m_lens_info.save!

          success_num += 1
        rescue => e
          pp e.message
          fail_num += 1
        end
      end
    end

    CollectResult.new(m_shop_info_id: $shop_id, success_num: success_num, fail_num: fail_num).save!
  end

  # 大沢カメラ
  def self.target_6(collect_targets)
    info_page_pattern = Regexp.new("/archives\/\\d+.html")
    price_pattern = Regexp.new("商品価格：￥(\\d+)-")
    sold_out_pattern = Regexp.new("sold out")

    session = TaskCommon::get_session

    success_num = 0
    fail_num = 0
    collect_targets.each do |collect_target|
      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|
        next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

        # sleep [*2..5].sample # アクセスタイミングを分散させる

        # 対象URLに遷移する
        session.visit collect_target.list_url

        # レンズ情報を取得する
        session.all(:css, '#contents .block').each do |article|
          raw_lens_info = {
            lens_name: nil,
            lens_info_url: nil,
            lens_pic_url: nil,
            stock_state: nil,
            price: 0,
            m_shop_info_id: $shop_id,
            memo: nil,
          }
          lens_info = nil

          start_flag = false
          element_count = 0

          begin
            article.all(:css, 'td').each do |iarticle|
              if start_flag
                element_count += 1

                if element_count == 1 # イ-7407
                  lens_info[:memo] = iarticle.text.strip
                elsif element_count == 2 # M42マウント ドイツ製 Isco-Göttingen Westromat 50mm/f1.9 前後キャップ付 http://t.co/hCxmWSncmz 試し撮り画像
                  lens_info[:lens_name] = iarticle.text.split('http')[0]
                elsif element_count == 3 # ￥32,800- sold out
                  prices = iarticle.text.split('-')
                  lens_info[:price] = prices[0].strip.gsub(/￥|,/, '')
                  lens_info[:stock_state] = !sold_out_pattern.match(prices[1]).present?
                elsif element_count == 4 # src="img/i-7317-thumbnail.jpg"
                  lens_info[:lens_pic_url] = iarticle.find(:css, 'img')[:src].gsub(/-thumbnail/, '')

                  # upsert
                  if m_lens_info = MLensInfo.where(memo: lens_info[:memo], m_shop_info_id: $shop_id).first
                    m_lens_info.attributes = lens_info
                  else
                    m_lens_info = MLensInfo.new(lens_info)
                  end

                  m_lens_info.save!

                  success_num += 1

                  start_flag = false
                  element_count = 0
                end
              end

              if !start_flag && iarticle.text.strip == '写真'
                lens_info = Marshal.load(Marshal.dump(raw_lens_info))
                start_flag = true 
              end
            end
          rescue => e
            pp e.message
            fail_num += 1
          end
        end
      end
    end
pp success_num
pp fail_num

    CollectResult.new(m_shop_info_id: $shop_id, success_num: success_num, fail_num: fail_num).save!
  end

end