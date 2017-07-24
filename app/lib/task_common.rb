require 'phantomjs'

class TaskCommon
  # Capybara初期設定
  def self.get_session
    # ユーザエージェントはランダムで設定する
    http_user_agent = [
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36",
      # "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Mobile Safari/537.36",
      # "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1",
      ].sample

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {
        headers: {
          HTTP_USER_AGENT: http_user_agent,
        },
        js_errors: false,
        timeout: 2500,
        phantomjs_options: [
          '--load-images=no',
          '--ignore-ssl-errors=yes',
          '--ssl-protocol=any'],
        phantomjs: Phantomjs.path,
      })
    end

    session = Capybara::Session.new(:poltergeist)
  end

  # ログ出力先設定
  def self.set_log(log_name)
    FileUtils.mkdir_p("log/#{log_name}") unless FileTest.exist?("log/#{log_name}")
    Rails.logger = Logger.new("log/#{log_name}.log", 'daily')
  end
end