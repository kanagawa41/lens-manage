# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

require File.expand_path(File.dirname(__FILE__) + "/environment")
set :output, 'log/cron.log'
# ジョブの実行環境の指定
# set :environment, :development
set :environment, :production

# FIXME: 本システムに合わせて作り直す

# ページ数取得
every '5 0 */2 * * ' do
  rake "fetch_lens_info:all:page_num"
end
# ページ情報取得
every '10 0 */2 * * ' do
  rake "fetch_lens_info:all:page_info"
end

# レンズ情報解析(f値、焦点距離)
every '11 1 */2 * * ' do
  rake "analytics_lens:all:lnes_info"
end

# 画像取得
every '21 1 */2 * * ' do
  rake "fetch_lens_info:all:lens_image"
end

# レンズ関連ワード解析
# Google検索数の上限に引っかからないように調整する
every '5,35 4-5,7-8,10-11,13-14,16-17,19-20,22-23/1 * * * ' do
  rake "analytics_lens:lens_related_word_with_google"
end

# レンズ関連ワード解析2
every '45 4-23/1 * * * ' do
  rake "analytics_lens:all:word_ranking"
end

# # 毎日00:05分
# every '5 0 * * * ' do
#   rake "brand_group:fetch"
# end

# # 毎日00:10分
# every '10 0 * * * ' do
#   rake "brand:fetch"
# end

# # 毎日00:35分
# every '35 0 * * * ' do
#   rake "category:fetch"
# end

# # 毎日１時間毎(5分に実行、0時は除く)
# every '5 1-23/1 * * * ' do
#   rake "page:fetch"
# end

# # 毎日20分毎(0時は除く)
# every '10-59/25 1-23 * * * ' do
#   rake "item:fetch"
# end

# http://www.japan9.com/cgi/cron.cgi
# http://morizyun.github.io/blog/whenever-gem-rails-ruby-capistrano/
# # 出力先のログファイルの指定
# set :output, 'log/crontab.log'
# # ジョブの実行環境の指定
# set :environment, :production
# # 3時間毎に実行するスケジューリング
# every 3.hours do
#   runner 'MyModel.some_process'
#   rake 'my:rake:task'
#   command '/usr/bin/my_great_command'
# end
# # 毎日 am4:30のスケジューリング
# every 1.day, at: '4:30 am' do
#   runner 'MyModel.task_to_run_at_four_thirty_in_the_morning'
# end
# # 一時間毎のスケジューリング
# every :hour do # Many shortcuts available: :hour, :day, :month, :year, :reboot
#   runner 'SomeModel.ladeeda'
# end
# # 日曜日のpm12時にスケジューリング
# every :sunday, at: '12pm' do # Use any day of the week or :weekend, :weekday
#   runner 'Task.do_something_great'
# end
# # crontab型の設定「分」「時」「日」「月」「曜日」
# # 毎月27日〜31日まで0:00に実行
# every '0 0 27-31 * * ' do
#   command 'echo 'you can use raw cron syntax too''
# end
# # 6-24時まで3時間おきに実行
# work_hour_per_two = (6..24).select{ |_| _%3 == 0 }.map {|_| "#{_}:00" }
# every 1.day, at: work_hour_per_two do
#   rake 'my:rake:task'
# end
#
# # wheneverの設定更新
# RAILS_ENV=development bundle exec whenever --update-crontab
# # crontabの設定削除
# RAILS_ENV=development bundle exec whenever --clear-crontab
