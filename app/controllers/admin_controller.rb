class AdminController < ApplicationController
  layout "basic"

  # 参考
  # https://github.com/ruby-openstack/ruby-openstack/wiki/Object-Storage
  def conoha_list
    @js_tree, @container_metadata, @file_stamp = AdminService::conoha_list(params[:force_fetch_flag])
    if params[:force_fetch_flag]
      redirect_to action: "conoha_list"
    end
  end

  # TODO: ajax通信で実行できるようにする
  def delete_objects
    if request.xhr?
      render json: { errors: ["Ajax通信のみ許容"] }, :status => 403
      return
    end

    unless params[:admin][:file_paths].present?
      render json: { errors: ["削除対象パスを返却して下さい。"] }, :status => 400
      return
    end

    no_exist_objects, ignore_objects = AdminService::delete_objects(params[:admin][:file_paths])
    render json: { data: {
      no_exist_objects: no_exist_objects,
      ignore_objects: ignore_objects,
    }}
  end

  private

end
