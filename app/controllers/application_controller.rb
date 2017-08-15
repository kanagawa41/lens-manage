class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  # アプリではJA、管理画面ではENを使用するため
  def set_locale
    I18n.locale = :ja
  end
end
