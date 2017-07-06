namespace :category do
  desc "カテゴリ情報を操作する"
  require 'capybara/poltergeist'
  task fetch: :environment do
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 1000 })
    end

    session = Capybara::Session.new(:poltergeist)
    # 対象URLに遷移する
    session.visit "https://www.mercari.com/jp/category/1/"

    # 全てのアンカーを取得する 
    session.all(:xpath, '//a').each do |anchor|
      puts anchor[:href]
    end

    # CSSスタイルでFINDする
    puts session.all(:css, 'a')[0][:href]

  end

end
