class LensListsController < ApplicationController
  layout "to_c"
  before_action :init_setting, :normalize_page

  def top
    @m_lens_infos = LensListsService.top
    @proper_nouns = LensListsService.footer
  end

  def index
    @title = 'レンズを探す'
    @m_lens_infos = LensListsService.index(params, params[:page])
    @q = params[:q]
    @f_num = params[:f_num]
    @focal_length = params[:focal_length]
    @proper_nouns = LensListsService.footer
    @m_lens_info = MLensInfo
  end

  def tag
    @title = params[:tag]

    # FIXME: 検索でおちている模様
    # tag = params[:tag]
    # m_proper_noun = MProperNoun.where(name_jp: tag).or(name_en: tag).first
    # unless m_proper_noun.present?
    #   render_404
    #   return
    # end

    # @m_lens_infos = LensListsService.tag(params, params[:page], m_proper_noun)
    @m_lens_infos = LensListsService.index(params, params[:page])
    @q = params[:q]
    @f_num = params[:f_num]
    @focal_length = params[:focal_length]
    @proper_nouns = LensListsService.footer
    @m_lens_info = MLensInfo
    render 'index'
  end

  def open_info
    m_lens_info = LensListsService.open_info(params[:lens_info_id])
    redirect_to m_lens_info[:lens_info_url]
  end

  def about
    @title = 'サイトについて'
    @hide_search_bar = true
  end

  def contact
    @title = 'お問い合わせ'
    @hide_search_bar = true
    
  end

  private 
  def init_setting
    @title = 'トップ'
  end

  # page パラメータを手動で設定された場合の対策
  def normalize_page
    page = params[:page].to_i
    params[:page] = (page <= 1 || page > Kaminari.config.max_pages.to_i) ? nil : page
  end

end