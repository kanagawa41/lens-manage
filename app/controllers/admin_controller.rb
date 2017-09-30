class AdminController < ApplicationController
  layout "basic"

  # 参考
  # https://github.com/ruby-openstack/ruby-openstack/wiki/Object-Storage
  def conoha_list
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

    @js_tree_json = AdminService::conoha_list @conoha_container.objects
  end
end
