class LensListsController < ApplicationController
  layout "to_c"
  before_action :init_setting

  def top
    @m_lens_infos = LensListsService.top
  end

  def index
    if @q = params[:q]
      @m_lens_infos = LensListsService.index(params[:q], params[:page])
      @q = params[:q]
    end
  end

  def about
    
  end

  def contact
    
  end

  private 
  def init_setting
    @title = 'トップ'
  end

end
