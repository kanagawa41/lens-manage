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
  end

  private

end
