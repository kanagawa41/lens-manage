class MShopInfosController < ApplicationController
  before_action :set_m_shop_info, only: [:show, :edit, :update, :destroy]

  # GET /m_shop_infos
  # GET /m_shop_infos.json
  def index
    @m_shop_infos = MShopInfo.all
  end

  # GET /m_shop_infos/1
  # GET /m_shop_infos/1.json
  def show
  end

  # GET /m_shop_infos/new
  def new
    @m_shop_info = MShopInfo.new
  end

  # GET /m_shop_infos/1/edit
  def edit
  end

  # POST /m_shop_infos
  # POST /m_shop_infos.json
  def create
    @m_shop_info = MShopInfo.new(m_shop_info_params)

    respond_to do |format|
      if @m_shop_info.save
        format.html { redirect_to @m_shop_info, notice: 'M shop info was successfully created.' }
        format.json { render :show, status: :created, location: @m_shop_info }
      else
        format.html { render :new }
        format.json { render json: @m_shop_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /m_shop_infos/1
  # PATCH/PUT /m_shop_infos/1.json
  def update
    respond_to do |format|
      if @m_shop_info.update(m_shop_info_params)
        format.html { redirect_to @m_shop_info, notice: 'M shop info was successfully updated.' }
        format.json { render :show, status: :ok, location: @m_shop_info }
      else
        format.html { render :edit }
        format.json { render json: @m_shop_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /m_shop_infos/1
  # DELETE /m_shop_infos/1.json
  def destroy
    @m_shop_info.destroy
    respond_to do |format|
      format.html { redirect_to m_shop_infos_url, notice: 'M shop info was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_m_shop_info
      @m_shop_info = MShopInfo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def m_shop_info_params
      params.require(:m_shop_info).permit(:shop_name, :shop_url)
    end
end
