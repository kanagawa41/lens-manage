class CollectTargetsController < ApplicationController
  before_action :set_collect_target, only: [:show, :edit, :update, :destroy]

  # GET /collect_targets
  # GET /collect_targets.json
  def index
    @collect_targets = CollectTarget.all
  end

  # GET /collect_targets/1
  # GET /collect_targets/1.json
  def show
  end

  # GET /collect_targets/new
  def new
    @collect_target = CollectTarget.new
  end

  # GET /collect_targets/1/edit
  def edit
  end

  # POST /collect_targets
  # POST /collect_targets.json
  def create
    @collect_target = CollectTarget.new(collect_target_params)

    respond_to do |format|
      if @collect_target.save
        format.html { redirect_to @collect_target, notice: 'Collect target was successfully created.' }
        format.json { render :show, status: :created, location: @collect_target }
      else
        format.html { render :new }
        format.json { render json: @collect_target.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collect_targets/1
  # PATCH/PUT /collect_targets/1.json
  def update
    respond_to do |format|
      if @collect_target.update(collect_target_params)
        format.html { redirect_to @collect_target, notice: 'Collect target was successfully updated.' }
        format.json { render :show, status: :ok, location: @collect_target }
      else
        format.html { render :edit }
        format.json { render json: @collect_target.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collect_targets/1
  # DELETE /collect_targets/1.json
  def destroy
    @collect_target.destroy
    respond_to do |format|
      format.html { redirect_to collect_targets_url, notice: 'Collect target was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collect_target
      @collect_target = CollectTarget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collect_target_params
      params.require(:collect_target).permit(:m_shop_info_id, :list_url, :start_page_num, :end_page_num)
    end
end
