class LensListsController < ApplicationController
  layout "to_c"
  before_action :init_setting

  def top
    @m_lens_infos = LensListsService.top
  end

  def index
    @m_lens_infos = LensListsService.index(params[:q])
  end

  private 
  def init_setting
    @title = 'トップ'
  end

end
