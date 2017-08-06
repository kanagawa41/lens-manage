class LensListsController < ApplicationController
  # GET /m_shop_infos
  # GET /m_shop_infos.json
  def index
    @m_lens_infos = MLensInfo.where.not(lens_info_url: nil).order(:created_at).limit(10).all
  end
end
