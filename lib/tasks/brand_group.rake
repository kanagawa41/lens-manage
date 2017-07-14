namespace :brand_group do
  desc "ブランドグループ情報を操作する"
  require 'capybara/poltergeist'
  task fetch: :environment do
    # ログ設定
    log_name = "brand_group-fetch"
    Rails.logger = Logger.new("log/#{log_name}.log", 'daily')

    brand_group = Regexp.new(
      "^#{Rails.application.config.urls['mercari_brand_domain']}" +
      "\\?brand_group_id=(\\d+)"
    )

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {
        js_errors: false,
        timeout: 1000,
        phantomjs_options: [
          '--load-images=no',
          '--ignore-ssl-errors=yes',
          '--ssl-protocol=any'],
      })
    end

    session = Capybara::Session.new(:poltergeist)

    # 対象URLに遷移する
    session.visit Rails.application.config.urls['mercari_brand_domain']

    groups = {}
    # 全てのアンカーを取得する 
    session.all(:css, '.brand-group-link-box a').each do |anchor|
      href = anchor[:href]
      if href =~ brand_group
        groups[href.match(brand_group)[1]] = anchor[:text].strip
      end
    end

    m_brand_groups = MBrandGroup.select(:id, :brand_group_name).all
    m_brand_group_ids = m_brand_groups.map{|record| record[:id]}

    change_ids = {insert_ids: [], update_ids: {}, error_ids: {}}

    groups.each do |id, group_name|
      if brand_group_index = m_brand_group_ids.index(id.to_i)
        if group_name != m_brand_groups[brand_group_index][:brand_group_name]
          MBrandGroup.where(id: id).update_all(brand_group_name: group_name)

          change_ids[:update_ids][id] = {before_name: m_brand_groups[brand_group_index][:brand_group_name], after_name: group_name}
        end
      else
        begin
          MBrandGroup.create!(id: id, brand_group_name: group_name)
        rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid => e
          change_ids[:error_ids][id] = {id => e.message}
          next
        end

        change_ids[:insert_ids].push id
      end
    end

    Rails.logger.info "change_ids: #{change_ids}"
  end
end
