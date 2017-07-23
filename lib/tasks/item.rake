namespace :item do
  desc "アイテム情報を操作する"
  require 'capybara/poltergeist'
  task fetch: :environment do
    # ログ設定
    log_name = "item-fetch"
    Rails.logger = Logger.new("log/#{log_name}.log", 'daily')

    # 最大検索数
    MAX_SEARCH_NUM = 50

    # ユーザドメイン検出用
    mercari_user_domain = Regexp.new("^#{Rails.application.config.urls['mercari_user_domain']}" +
      "(\\d+)/")

    # 通常カテゴリー検出
    category_domain = Regexp.new(
      "^#{Rails.application.config.urls['mercari_category_list_domain']}" + 
      "(\\d+)/"
    )

    # 通常ブランド検出
    brand_domain = Regexp.new(
      "^#{Rails.application.config.urls['mercari_brand_domain']}" + 
      "(\\d+)/"
    )

    ITEM_BASE_DOMAIN = Rails.application.config.urls['mercari_item_domain'] + 'm'

    # マスターデータ取得
    m_prefectures = MPrefecture.select(:id, :prefecture_name).all.map{|record| {id: record[:id], prefecture_name: record[:prefecture_name]}}
    m_goods_statuses = MGoodsStatus.select(:id, :status_description).all.map{|record| {id: record[:id], status_description: record[:status_description]}}
    m_delivery_burdens = MDeliveryBurden.select(:id, :burdender).all.map{|record| {id: record[:id], burdender: record[:burdender]}}

    item_ids = HtmlWarehouse.select(:item_id).where(http_status: nil).limit(MAX_SEARCH_NUM).all.map{|record| record[:item_id]}
    # item_ids = [85333989392]

    session = TaskCommon::get_session

    insert_errors = []
    item_ids.each do |item_id|
      begin
        sleep [*2..5].sample # アクセスタイミングを分散させる
        @item_id_g = item_id

        # 対象URLに遷移する
        session.visit ITEM_BASE_DOMAIN + item_id.to_s


        # FIXME: 削除判定を行う
        # session.find(:css, '.deleted-item-name').text.strip

        item_details = {
          goods_name: nil,
          ima_url: [nil, nil, nil, nil], 
          user_info: {
            id: nil,
            name: nil,
            status: [nil, nil, nil],
          },
          category: [nil, nil, nil],
          brand: nil,
          goods_status: nil,
          burdender: nil,
          prefecture: nil,
          price: nil,
          description: nil,
          like_num: nil,
          options: {},
        }

        # 価格を取得
        item_details[:goods_name] = session.find(:css, '.item-name').text.strip

        # イメージURLを取得(MAX４枚)
        session.all(:css, 'div.owl-item-inner img').each_with_index do |img, i|
          item_details[:ima_url][i] = img[:src]
        end

        # アイテム詳細を取得
        session.all(:css, 'table.item-detail-table tr').each do |tr|
          title = tr.find(:css, 'th').text.strip
          if title == "出品者"
            # ユーザ名前
            user_name_info = tr.find(:css, 'td a')
            item_details[:user_info][:id] = mercari_user_domain.match(user_name_info[:href])[1]
            item_details[:user_info][:name] = user_name_info.text.strip

            # ユーザステータス
            tr.all(:css, 'td .item-user-ratings').each_with_index do |icon, i|
              item_details[:user_info][:status][i] = icon.find(:css, 'span').text.strip
            end
          elsif title == "カテゴリー"
            tr.all(:css, 'a').each_with_index do |anchor, i|
              item_details[:category][i] = category_domain.match(anchor[:href])[1]
            end
          elsif title == "ブランド"
            tr.all(:css, 'a').each_with_index do |anchor, i|
              item_details[:brand] = brand_domain.match(anchor[:href])[1]
            end
          elsif title == "商品のサイズ" # 服のみ(Mなど)
            item_details[:options]['size'] = tr.find(:css, 'td').text.strip
          elsif title == "商品の状態"
            status_name = tr.find(:css, 'td').text.strip

            m_goods_statuses.each do |m_goods_statuse|
              if status_name == m_goods_statuse[:status_description]
                item_details[:goods_status] = m_goods_statuse[:id]
                break
              end
            end
          elsif title == "配送料の負担"
            deriver_name = tr.find(:css, 'td').text.strip

            m_delivery_burdens.each do |m_delivery_burden|
              if deriver_name == m_delivery_burden[:burdender]
                item_details[:burdender] = m_delivery_burden[:id]
                break
              end
            end
          elsif title == "配送元地域"
            region_name = tr.find(:css, 'td').text.strip

            m_prefectures.each do |m_prefecture|
              if region_name == m_prefecture[:prefecture_name]
                item_details[:prefecture] = m_prefecture[:id]
                break
              end
            end
          end
        end

        # 価格を取得
        item_details[:price] = session.find(:css, '.item-price').text.strip.gsub(/¥|\s|,/, '')

        # 説明を取得
        item_details[:description] = session.find(:css, '.item-description')['innerHTML'].strip

        # Like数を取得
        item_details[:like_num] = session.find(:css, '[data-num="like"]').text.strip
   
        MItem.where(id: item_id).update_all(
          image_url1: item_details[:ima_url][0],
          image_url2: item_details[:ima_url][1],
          image_url3: item_details[:ima_url][2],
          image_url4: item_details[:ima_url][3],
          goods_name: item_details[:goods_name],
          goods_description: item_details[:description],
          price: item_details[:price],
          m_category_id1: item_details[:category][0],
          m_category_id2: item_details[:category][1],
          m_category_id3: item_details[:category][2],
          user_id:  item_details[:user_info][:id],
          m_goods_statuse_id: item_details[:goods_status],
          m_brand_id: item_details[:burdender],
          m_delivery_burden_id: item_details[:burdender],
          m_prefecture: item_details[:prefecture],
          like_num: item_details[:like_num],
          options: item_details[:options].to_json,
        )

        HtmlWarehouse.where(item_id: item_id).update_all(
          html: session.find(:css, 'main')['innerHTML'].strip,
          http_status: session.status_code,
        )

        user = User.where(id: item_details[:user_info][:id])

        if user.size == 1
          user.update_all(
            good_rating: item_details[:user_info][:status][0],
            normal_rating: item_details[:user_info][:status][1],
            bad_rating: item_details[:user_info][:status][2],
          )
        else
          begin
            User.create(
              id: item_details[:user_info][:id],
              user_name: item_details[:user_info][:name],
              good_rating: item_details[:user_info][:status][0],
              normal_rating: item_details[:user_info][:status][1],
              bad_rating: item_details[:user_info][:status][2],
            )
          rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid => e
            insert_errors << {id => e.message}
            next
          end
        end
        # pp item_details
      rescue=> e
        Rails.logger.error "#{@item_id_g}: #{e.message}"
        HtmlWarehouse.where(item_id: @item_id_g).update_all(
          http_status: 404,
        )
      end
    end

    Rails.logger.info "insert_errors: #{insert_errors}"
  end
end
