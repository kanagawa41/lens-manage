namespace :page do
  desc "ページ情報を操作する"
  require 'capybara/poltergeist'
  task fetch: :environment do
    # ログ設定
    log_name = "page-fetch"
    Rails.logger = Logger.new("log/#{log_name}.log", 'daily')

    # アイテムドメイン検出用
    mercari_item_domain = Regexp.new("^#{Rails.application.config.urls['mercari_item_domain']}")

    CATEGORY_BASE_DOMAIN = Rails.application.config.urls['mercari_category_list_domain']

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 1000 })
    end

    session = Capybara::Session.new(:poltergeist)

    MCategory.select("m_categories.id, category_pages.range").joins(:category_pages).where("category_pages.complete_flag"=> false).where("m_categories.is_big_category"=> true).all.each do |m_category|
      ranges = m_category.range.split(':')
      m_category_id = m_category.id

      Range.new(ranges[0].to_i, ranges[1].to_i).to_a.each do |num|
        session.visit "#{CATEGORY_BASE_DOMAIN}#{m_category_id}/?page=#{num}"

        item_urls = []
        # 全てのアンカーを取得する 
        # href="https://item.mercari.com/jp/m48141250656/"
        session.all(:css, 'a').each do |anchor|
          if anchor[:href] =~ mercari_item_domain
            item_urls << anchor[:href]
          end
        end
    pp item_urls
break
      end
break
    end

  end
end
