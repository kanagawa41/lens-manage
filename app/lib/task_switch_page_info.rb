class TaskSwitchPageInfo
  require 'nkf'

  def self.fetch(shop_id)
    collect_targets = CollectTarget.select(:id, :list_url, :start_page_num, :end_page_num).where(m_shop_info_id: shop_id).all

    $shop_id = shop_id
    # 更新されたレンズID
    $fetch_lens_ids = []

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
    elsif shop_id == 7 # アカサカカメラ
      target_7 collect_targets
    elsif shop_id == 8 # 喜久屋カメラ
      target_8 collect_targets
    elsif shop_id == 9 # フラッシュバックカメラ
      target_9 collect_targets
    elsif shop_id == 10 # 大貫カメラ
      target_10 collect_targets
    elsif shop_id == 11 # カメラのマツバラ光機
      target_11 collect_targets
    elsif shop_id == 12 # OSカメラ
      target_12 collect_targets
    elsif shop_id == 13 # ブリコラージュ工房NOCTO
      target_13 collect_targets
    elsif shop_id == 14 # KING-2
      target_14 collect_targets
    else
      raise "#{shop_id}(存在しない)"
    end

    old_lens_ids = MLensInfo.select(:id).where(m_shop_info_id: $shop_id, old_flag: false).all.map{|r| r[:id]} - $fetch_lens_ids
    # 今回更新されなかったレンズを古いとみなす
    MLensInfo.where(m_shop_info_id: $shop_id).where(id: old_lens_ids).update(old_flag: true)
  rescue => e
    raise "m_shop_info_idが#{$shop_id}のページ数が取得できませんでした。: #{e.message}"
  end

  private

  # 動的なページの値にマッチさせる
  PAGE_MATCH_STR = "\\[\\$page\\]"

  # レモン社
  def self.target_1(collect_targets)
    info_page_pattern = Regexp.new("/shop\/g\/.+/")
    avarable_stock_pattern = Regexp.new("在庫状況：○")

    session = TaskCommon::get_session

    success_num = 0
    fail_num = 0
    collect_targets.each do |collect_target|
      next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|

        TaskCommon::access_sleep

        # 対象URLに遷移する
        session.visit collect_target.list_url.gsub(/#{PAGE_MATCH_STR}/, num.to_s)

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
              old_flag: false,
            }
            metadata = article.text

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

            $fetch_lens_ids << m_lens_info.id

            upsert_warehouse({ m_lens_info_id: m_lens_info.id, metadata: metadata })

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
      next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|

        TaskCommon::access_sleep

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
              old_flag: false,
            }
            metadata = article.text

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

            $fetch_lens_ids << m_lens_info.id

            upsert_warehouse({ m_lens_info_id: m_lens_info.id, metadata: metadata })

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
      next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|

        TaskCommon::access_sleep

        # 対象URLに遷移する
        session.visit collect_target.list_url.gsub(/#{PAGE_MATCH_STR}/, num.to_s)

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
              old_flag: false,
            }
            metadata = article.text

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

            $fetch_lens_ids << m_lens_info.id

            upsert_warehouse({ m_lens_info_id: m_lens_info.id, metadata: metadata })

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
      next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|

        TaskCommon::access_sleep

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
              metadata: article.text,
              old_flag: false,
            }
            metadata = article.text

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

            $fetch_lens_ids << m_lens_info.id

            upsert_warehouse({ m_lens_info_id: m_lens_info.id, metadata: metadata })

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

      TaskCommon::access_sleep

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
            old_flag: false,
          }
          metadata = article.text

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

          $fetch_lens_ids << m_lens_info.id

          upsert_warehouse({ m_lens_info_id: m_lens_info.id, metadata: metadata })

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
      next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|

        TaskCommon::access_sleep

        # 対象URLに遷移する
        session.visit collect_target.list_url

        # レンズ情報を取得する
        session.all(:css, '#contents .block').each do |article|
          raw_lens_info = {
            lens_name: nil,
            lens_info_url: collect_target.list_url,
            lens_pic_url: nil,
            stock_state: nil,
            price: 0,
            m_shop_info_id: $shop_id,
            memo: nil,
            old_flag: false,
          }
          metadata = article.text

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

                  $fetch_lens_ids << m_lens_info.id

                  upsert_warehouse({ m_lens_info_id: m_lens_info.id, metadata: metadata })

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

    CollectResult.new(m_shop_info_id: $shop_id, success_num: success_num, fail_num: fail_num).save!
  end

  # アカサカカメラ
  def self.target_7(collect_targets)
    sold_out_pattern = Regexp.new("SOLD OUT")

    session = TaskCommon::get_session

    success_num = 0
    fail_num = 0
    collect_targets.each do |collect_target|
      next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|

        TaskCommon::access_sleep

        # 対象URLに遷移する
        session.visit collect_target.list_url

        # レンズ情報を取得する
        session.all(:css, 'center table[width="915"]').each do |article|
          begin
            lens_info = {
              lens_name: nil,
              lens_info_url: collect_target.list_url,
              lens_pic_url: nil,
              stock_state: nil,
              price: 0,
              m_shop_info_id: $shop_id,
              old_flag: false,
            }
            metadata = article.text

            lens_info[:lens_name] = article.find(:css, 'td[bgcolor="#ffff00"] b').text.gsub(/\r|\n|\t/, ' ').strip
            # FIXME 多分ここが取得できない場合がある。
            images = article.all(:css, 'td a img')
            if images.present?
              lens_info[:lens_pic_url] = images[0][:src].strip
            else
              next # 画像のない情報は無視する。
            end

            price = article.find(:css, 'td[width="744"] b').text.strip
            if price.match(sold_out_pattern)
              lens_info[:price] = nil
              lens_info[:stock_state] = false
            else
              lens_info[:price] = price.strip.gsub(/円|,/, '')
              lens_info[:stock_state] = true
            end

            # upsert
            if m_lens_info = MLensInfo.where(lens_name: lens_info[:lens_name], m_shop_info_id: $shop_id).first
              m_lens_info.attributes = lens_info
            else
              m_lens_info = MLensInfo.new(lens_info)
            end

            m_lens_info.save!

            $fetch_lens_ids << m_lens_info.id

            upsert_warehouse({ m_lens_info_id: m_lens_info.id, metadata: metadata })

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

  # 喜久屋カメラ
  def self.target_8(collect_targets)
    session = TaskCommon::get_session

    success_num = 0
    fail_num = 0
    collect_targets.each do |collect_target|
      next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|

        TaskCommon::access_sleep

        # 対象URLに遷移する
        session.visit collect_target.list_url

        # レンズ情報を取得する
        session.all(:css, '#main .item_box').each do |article|
          begin
            lens_info = {
              lens_name: nil,
              lens_info_url: nil,
              lens_pic_url: nil,
              stock_state: nil,
              price: 0,
              m_shop_info_id: $shop_id,
              old_flag: false,
            }
            metadata = article.text

            lens_info[:lens_name] = article.find(:css, '.item_name').text.gsub(/\r|\n|\t/, ' ').strip
            lens_info[:lens_info_url] = article.find(:css, '.item_name a')[:href].to_s
            lens_info[:lens_pic_url] = article.find(:css, 'img')[:src]

            lens_info[:price] = article.find(:css, '.item_price').text.delete("^0-9")
            # 売り切れになったら別ページに表示される
            lens_info[:stock_state] = true

            # upsert
            if m_lens_info = MLensInfo.where(lens_info_url: lens_info[:lens_info_url], m_shop_info_id: $shop_id).first
              m_lens_info.attributes = lens_info
            else
              m_lens_info = MLensInfo.new(lens_info)
            end

            m_lens_info.save!

            $fetch_lens_ids << m_lens_info.id

            upsert_warehouse({ m_lens_info_id: m_lens_info.id, metadata: metadata })

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

  # フラッシュバックカメラ
  def self.target_9(collect_targets)
    session = TaskCommon::get_session

    success_num = 0
    fail_num = 0
    collect_targets.each do |collect_target|
      next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|
        TaskCommon::access_sleep

        # 対象URLに遷移する
        session.visit collect_target.list_url.gsub(/#{PAGE_MATCH_STR}/, num.to_s)

        # レンズ情報を取得する
        session.all(:css, 'table.shortlist tr[valign="middle"]').each do |article|
          begin
            lens_info = {
              lens_name: nil,
              lens_info_url: nil,
              lens_pic_url: nil,
              stock_state: nil,
              price: 0,
              m_shop_info_id: $shop_id,
              old_flag: false,
            }
            metadata = article.text

            lens_info[:lens_name] = article.find(:css, '.compact').text.gsub(/\r|\n|\t/, ' ').strip
            lens_info[:lens_info_url] = article.find(:css, '.product-image a')[:href]
            lens_info[:lens_pic_url] = article.find(:css, '.product-image img')[:src]

            if article.all(:css, '.price').present?
              lens_info[:price] = article.all(:css, '.price')[1].text.delete("^0-9")
              lens_info[:stock_state] = true
            else
              lens_info[:stock_state] = false
            end

            # upsert
            if m_lens_info = MLensInfo.where(lens_info_url: lens_info[:lens_info_url], m_shop_info_id: $shop_id).first
              m_lens_info.attributes = lens_info
            else
              m_lens_info = MLensInfo.new(lens_info)
            end

            m_lens_info.save!

            $fetch_lens_ids << m_lens_info.id

            upsert_warehouse({ m_lens_info_id: m_lens_info.id, metadata: metadata })

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

  # 大貫カメラ
  def self.target_10(collect_targets)
    session = TaskCommon::get_session

    success_num = 0
    fail_num = 0
    collect_targets.each do |collect_target|
      next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|
        TaskCommon::access_sleep

        # 対象URLに遷移する
        session.visit collect_target.list_url.gsub(/#{PAGE_MATCH_STR}/, num.to_s)

        first_flag = false
        # レンズ情報を取得する
        session.all(:css, '.tabTable tr').each do |article|
          unless first_flag
            first_flag = true
            next
          end

          begin
            lens_info = {
              lens_name: nil,
              lens_info_url: nil,
              lens_pic_url: nil,
              stock_state: nil,
              price: 0,
              m_shop_info_id: $shop_id,
              old_flag: false,
            }
            metadata = article.text

            lens_info[:lens_name] = article.find(:css, '.itemTitle').text.gsub(/\r|\n|\t/, ' ').strip
            lens_info[:lens_info_url] = article.find(:css, '.itemTitle a')[:href]
            lens_info[:lens_pic_url] = article.find(:css, 'img.listingProductImage')[:src]

            infos = article.all(:css, '.productListing-data')
            # "60,000円  57,000円" と割引表示があるため
            lens_info[:price] = infos[3].text.split('円')[0].delete("^0-9")
            lens_info[:stock_state] = infos[4].text.delete("^0-9").to_i > 0

            # upsert
            if m_lens_info = MLensInfo.where(lens_info_url: lens_info[:lens_info_url], m_shop_info_id: $shop_id).first
              m_lens_info.attributes = lens_info
            else
              m_lens_info = MLensInfo.new(lens_info)
            end

            m_lens_info.save!

            $fetch_lens_ids << m_lens_info.id

            upsert_warehouse({ m_lens_info_id: m_lens_info.id, metadata: metadata })

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

  # カメラのマツバラ光機
  def self.target_11(collect_targets)
    sold_out_pattern = Regexp.new("Sold out", Regexp::IGNORECASE)

    session = TaskCommon::get_session

    success_num = 0
    fail_num = 0
    collect_targets.each do |collect_target|
      next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|
        TaskCommon::access_sleep

        # 対象URLに遷移する
        session.visit collect_target.list_url

        first_flag = false
        # レンズ情報を取得する
        session.all(:css, 'table[bgcolor="#C0C0C0"] tr').each do |article|
          # 区別ができない要素があるため、tdの個数で除外する
          # http://www.m-camera.com/hasselblad/hassel-lens.html
          next if article.all(:css, 'td').size < 4

          # ヘッダーを除外
          unless first_flag
            first_flag = true
            next
          end

          begin
            lens_info = {
              lens_name: nil,
              lens_info_url: collect_target.list_url,
              lens_pic_url: nil,
              stock_state: nil,
              price: 0,
              m_shop_info_id: $shop_id,
              old_flag: false,
            }
            metadata = article.text

            infos = article.all(:css, 'td')

            # 複数の要素が見つかる場合がある
            lens_info[:lens_name] = infos[0].all(:css, 'b')[0].text.gsub(/\r|\n|\t/, ' ').strip

            raw_price = infos[1].text
            if raw_price =~ sold_out_pattern
              lens_info[:price] = raw_price.delete("^0-9")
              lens_info[:stock_state] = 0
            else
              lens_info[:price] = raw_price.delete("^0-9")
              lens_info[:stock_state] = 1
            end

            # 複数の要素が見つかる場合がある
            lens_info[:lens_pic_url] = infos[2].all(:css, 'img')[0][:src]

            # upsert
            if m_lens_info = MLensInfo.where(lens_pic_url: lens_info[:lens_pic_url], m_shop_info_id: $shop_id).first
              m_lens_info.attributes = lens_info
            else
              m_lens_info = MLensInfo.new(lens_info)
            end

            m_lens_info.save!

            $fetch_lens_ids << m_lens_info.id

            upsert_warehouse({ m_lens_info_id: m_lens_info.id, metadata: metadata })

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

  # OSカメラ
  def self.target_12(collect_targets)
    session = TaskCommon::get_session

    success_num = 0
    fail_num = 0
    collect_targets.each do |collect_target|
      next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|
        TaskCommon::access_sleep

        # 対象URLに遷移する
        session.visit collect_target.list_url

        # レンズ情報を取得する
        session.all(:css, 'table tr[bgcolor="#000000"]').each do |article|
          # 区別ができない要素があるため、tdの個数で除外する
          next if article.all(:css, 'td').size < 6

          begin
            lens_info = {
              lens_name: nil,
              lens_info_url: nil,
              lens_pic_url: nil,
              stock_state: nil, # 在庫不明
              price: 0,
              m_shop_info_id: $shop_id,
              memo: nil,
              old_flag: false,
            }
            metadata = article.text

            infos = article.all(:css, 'td')

            lens_info[:lens_info_url] = infos[0].find(:css, 'a')[:href]
            lens_info[:lens_pic_url] = infos[0].find(:css, 'img')[:src]

            lens_info[:memo] = safe_lens_name infos[1].text

            lens_info[:lens_name] = safe_lens_name infos[2].text

            lens_info[:price] = safe_price infos[5].text

            # upsert
            if m_lens_info = MLensInfo.where(lens_info_url: lens_info[:lens_info_url], m_shop_info_id: $shop_id).first
              m_lens_info.attributes = lens_info
            else
              m_lens_info = MLensInfo.new(lens_info)
            end

            m_lens_info.save!

            $fetch_lens_ids << m_lens_info.id

            upsert_warehouse(m_lens_info_id: m_lens_info.id, metadata: metadata)

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

  # ブリコラージュ工房NOCTO
  def self.target_13(collect_targets)
    sold_out_pattern = Regexp.new("品切れ")
    no_image_url = "\\/images\\/common\\/nonimg90\\.gif"
    
    session = TaskCommon::get_session

    success_num = 0
    fail_num = 0
    collect_targets.each do |collect_target|
      next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|
        sleep [*2..5].sample # アクセスタイミングを分散させる

        # 対象URLに遷移する
        session.visit collect_target.list_url.gsub(/#{PAGE_MATCH_STR}/, num.to_s)

        # レンズ情報を取得する
        session.all(:css, '#M_categoryList table tr td table').each do |article|
          begin
            lens_info = {
              lens_name: nil,
              lens_info_url: nil,
              lens_pic_url: nil,
              stock_state: nil,
              price: 0,
              m_shop_info_id: $shop_id,
            }
            metadata = article.text

            lens_info[:lens_info_url] = article.all(:css, 'table tr td a')[0][:href]

            pic_url = article.all(:css, 'table tr td img')[0][:src]

            if pic_url.present?
              lens_info[:lens_pic_url] = pic_url unless pic_url.match(/#{no_image_url}/)
            end

            name_and_price = article.all(:css, 'td table tr.woong')

            lens_info[:lens_name] = safe_lens_name name_and_price[0].find(:css, 'a').text
            lens_info[:stock_state] = !sold_out_pattern.match(name_and_price[0].text).present?
            lens_info[:price] = safe_price safe_lens_name name_and_price[3].text

            # upsert
            if m_lens_info = MLensInfo.where(lens_info_url: lens_info[:lens_info_url], m_shop_info_id: $shop_id).first
              m_lens_info.attributes = lens_info
            else
              m_lens_info = MLensInfo.new(lens_info)
            end

            m_lens_info.save!

            upsert_warehouse({ m_lens_info_id: m_lens_info.id, metadata: metadata })

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

  # KING-2
  def self.target_14(collect_targets)
    sold_out_str = "販売済"
    session = TaskCommon::get_session

    success_num = 0
    fail_num = 0
    collect_targets.each do |collect_target|
      next unless collect_target.start_page_num.present? && collect_target.end_page_num.present?

      Range.new(collect_target.start_page_num, collect_target.end_page_num).each do |num|
        TaskCommon::access_sleep

        # 対象URLに遷移する
        session.visit collect_target.list_url

        # レンズ情報を取得する
        session.all(:css, '#undercolumn .list_block').each do |article|
          begin
            lens_info = {
              lens_name: nil,
              lens_info_url: nil,
              lens_pic_url: nil,
              stock_state: nil,
              price: 0,
              m_shop_info_id: $shop_id,
              memo: nil,
              old_flag: false,
            }
            metadata = article.text

            lens_info[:lens_info_url] = article.find(:css, '.listphoto a')[:href]
            lens_info[:lens_pic_url] = article.find(:css, '.listphoto img')[:src]

            lens_info[:stock_state] = !article.all(:css, '.status_icon img').map{|r| r[:alt]}.include?(sold_out_str)

            lens_info[:lens_name] = safe_lens_name article.find(:css, '.listrightbloc h3').text

            lens_info[:price] = safe_price article.all(:css, '.price span')[0].text

            # upsert
            if m_lens_info = MLensInfo.where(lens_info_url: lens_info[:lens_info_url], m_shop_info_id: $shop_id).first
              m_lens_info.attributes = lens_info
            else
              m_lens_info = MLensInfo.new(lens_info)
            end

            m_lens_info.save!

            $fetch_lens_ids << m_lens_info.id

            upsert_warehouse(m_lens_info_id: m_lens_info.id, metadata: metadata)

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

  # 安全に金額の値を取得する
  def self.safe_price(price_str)
    price_str.delete("^0-9")
  end

  # 安全にレンズ名を取得する
  def self.safe_lens_name(lens_name_str)
    convert_unity_name(lens_name_str.gsub(/\r|\n|\t/, ' ').strip)
  end

  # 統一性が取れるように名前に変換をかける
  def self.convert_unity_name(lens_name)
    return nil unless lens_name.present?

    convert_word = lens_name

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
  end

  # メタデータをupsertする
  def self.upsert_warehouse(attributes)
    # upsert
    if collect_warehouse = CollectWarehouse.where(m_lens_info_id: attributes[:m_lens_info_id]).first
      collect_warehouse.attributes = attributes
    else
      collect_warehouse = CollectWarehouse.new(attributes)
    end

    collect_warehouse.save!
  end

end