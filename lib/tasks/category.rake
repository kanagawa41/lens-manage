namespace :category do
  desc "カテゴリ情報を操作する"
  require 'capybara/poltergeist'
  task fetch: :environment do
    # ログ設定
    log_name = "category-fetch"
    Rails.logger = Logger.new("log/#{log_name}.log", 'daily')

    # 通常カテゴリー検出
    category_domain = Regexp.new(
      "^#{Rails.application.config.urls['mercari_category_list_domain']}" + 
      "(\\d+)/"
    )

    # 大カテゴリー検出用
    root_category = Regexp.new(
      "^#{Rails.application.config.urls['mercari_category_list_domain']}" +
      "#root_category-(\\d+)"
    )

    big_categories = {}
    categories = {}
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 1000 })
    end

    session = Capybara::Session.new(:poltergeist)

    # 対象URLに遷移する
    session.visit Rails.application.config.urls['mercari_category_list_domain']

    big_categories = {}
    categories = {}
    # 全てのアンカーを取得する 
    session.all(:css, 'a').each do |anchor|
      href = anchor[:href]
      if href =~ root_category
        big_categories[href.match(root_category)[1]] = anchor[:text]
      elsif href =~ category_domain
        categories[href.match(category_domain)[1]] = anchor[:text]
      end
    end

    categories.merge! big_categories

    m_categories = MCategory.select(:id, :category_name).all
    m_categories_ids = m_categories.map{|record| record[:id]}

    change_ids = {insert_ids: [], update_ids: {}}
    categories.each do |id, category_name|
      if category_index = m_categories_ids.index(id.to_i)
        if category_name != m_categories[category_index][:category_name]
          MCategory.where(id: id).update_all(category_name: category_name, is_big_category: !!big_categories[id])

          change_ids[:update_ids][id] = {before_name: m_categories[category_index][:category_name], after_name: category_name}
        end
      else
        MCategory.create(id: id, category_name: category_name, is_big_category: !!big_categories[id])
        # ページ分
        CategoryPage.create(m_category_id: id, range: "1:25")
        CategoryPage.create(m_category_id: id, range: "26:50")
        CategoryPage.create(m_category_id: id, range: "51:75")
        CategoryPage.create(m_category_id: id, range: "76:100")

        change_ids[:insert_ids].push id
      end
    end

    Rails.logger.info "change_ids: #{change_ids}"
  end

end
