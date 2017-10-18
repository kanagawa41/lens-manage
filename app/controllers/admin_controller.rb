class AdminController < ApplicationController
  require 'rake'

  layout "basic"

  # 参考
  # https://github.com/ruby-openstack/ruby-openstack/wiki/Object-Storage
  def conoha_list
    @js_tree, @container_metadata, @file_stamp = AdminService::conoha_list
  end

  # オブジェクトの削除
  def delete_objects_ajax
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

  # ツリーの更新(Ajax)
  def fetch_tree_datas_ajax
    if request.xhr?
      render json: { errors: ["Ajax通信のみ許容"] }, :status => 403
      return
    end

    js_tree, container_metadata, file_stamp = AdminService::fetch_tree_datas_ajax

    render json: { data: {
      js_tree: js_tree,
      container_metadata: container_metadata,
      file_stamp: file_stamp.strftime("%Y年%m月%d日 %H:%M:%S"),
    }}
  end

  # タグのリセット(Ajax)
  def reset_tags_ajax
    if request.xhr?
      render json: { errors: ["Ajax通信のみ許容"] }, :status => 403
      return
    end

    Rake::Task.new('analytics_lens:reset:add_tags', Rake.application).invoke

    render json: { data: {
      response: "ok",
    }}
  end

  # ワードランキングのリセット(Ajax)
  def reset_word_ranking
    if request.xhr?
      render json: { errors: ["Ajax通信のみ許容"] }, :status => 403
      return
    end

    Rake::Task.new('analytics_lens:reset:word_ranking', Rake.application).invoke

    render json: { data: {
      response: "ok",
    }}
  end

  private

end
