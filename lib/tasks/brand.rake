namespace :brand do
  desc "ブランド情報を操作する"
  require 'capybara/poltergeist'
  require 'phantomjs'
  task fetch: :environment do
    # ログ設定
    log_name = "brand-fetch"
    Rails.logger = Logger.new("log/#{log_name}.log", 'daily')

    # 通常ブランド検出
    brand_domain = Regexp.new(
      "^#{Rails.application.config.urls['mercari_brand_domain']}" + 
      "(\\d+)/"
    )

    # 大カテゴリー
    brand_group_base_domain = "#{Rails.application.config.urls['mercari_brand_domain']}?brand_group_id="

    brand_group_ids = []
    MBrandGroup.select(:id, :brand_group_name).all.map{|record| record[:id].to_s}.each do |id|
      brand_group_ids << id
    end

    m_brands = MBrand.select(:id, :brand_name).all
    m_brand_ids = m_brands.map{|record| record[:id]}

    session = TaskCommon::get_session

    change_ids = {insert_ids: [], update_ids: {}, error_ids: {}}
    brand_group_ids.each do |brand_group_id|
      sleep [*2..5].sample # アクセスタイミングを分散させる

      brand_group_domain = brand_group_base_domain + brand_group_id.to_s

      # 対象URLに遷移する
      session.visit brand_group_domain

      brands = {}
      # 全てのアンカーを取得する 
      session.all(:css, 'a').each do |anchor|
        href = anchor[:href]
        if href =~ brand_domain
          brands[href.match(brand_domain)[1]] = anchor[:text].strip
        end
      end

      brands.each do |id, brand_name|
        if brand_index = m_brand_ids.index(id.to_i)
          if brand_name != m_brands[brand_index][:brand_name]
            MBrand.where(id: id).update_all(brand_name: brand_name, brand_group_id: brand_group_id)

            change_ids[:update_ids][id] = {before_name: m_brands[brand_index][:brand_group_name], after_name: brand_name}
          end
        else
          begin
            MBrand.create(id: id, brand_name: brand_name, brand_group_id: brand_group_id)
          rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid => e
            change_ids[:error_ids][id] = {id => e.message}
            next
          end

          change_ids[:insert_ids].push id
        end
      end
    end
  
    Rails.logger.info "change_ids: #{change_ids}"
  end
end
