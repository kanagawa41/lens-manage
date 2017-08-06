namespace :collect_lens do
  # require 'capybara/poltergeist'

  desc "ページ数を取得する"
  task :page_num, ['target_shop'] => :environment do |task, args|
    TaskCommon::set_log 'collect_rends/page_num'

    TaskSwitchPageNum::fetch args[:target_shop].to_i
  end

  desc "ページ情報を取得する"
  task :page_info, ['target_shop'] => :environment do |task, args|
    TaskCommon::set_log 'collect_rends/fetch_list'

    TaskSwitchPageInfo::fetch args[:target_shop].to_i
  end

end
