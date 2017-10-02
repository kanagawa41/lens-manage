class AdminController < ApplicationController
  layout "basic"

  # 参考
  # https://github.com/ruby-openstack/ruby-openstack/wiki/Object-Storage
  def conoha_list
    fetch_object_info

    @js_tree, @cache_flag, @file_stamp = AdminService::conoha_list(@conoha_container, params[:force_fetch_flag])
    @raw_container_objects = @conoha_container.objects
  end

  private

  def fetch_object_info
    # オブジェクトストレージの接続情報
    conoha_obs_conf = Rails.application.config.api.conoha_object_strage
    os = OpenStack::Connection.create(
      username: conoha_obs_conf[:user_id],
      api_key: conoha_obs_conf[:password],
      authtenant_id: conoha_obs_conf[:tenant_id],
      auth_url: conoha_obs_conf[:auth_url],
      service_type: "object-store",
    )

    @container_name = conoha_obs_conf[:container_name]
    @conoha_container = os.container(@container_name)
  end
end
