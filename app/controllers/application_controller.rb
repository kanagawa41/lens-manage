class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_logger

  def set_logger
    $logger = Rails.logger
  end

  # 例外処理
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Exception, with: :render_500

  def render_404
    render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
  end

  def render_500
    render template: 'errors/error_500', status: 500, layout: 'application', content_type: 'text/html'
  end

  # COMMENT: ActiveAdminではlocalをenを使用していたが、jaが見つかったので対処が不要になった
  # before_action :set_locale
  # アプリではJA、管理画面ではENを使用するため
  # def set_locale
  #   if request.path =~ /^\/admin/
  #     I18n.locale = :en
  #   else
  #     I18n.locale = :ja
  #   end
  # end
end
