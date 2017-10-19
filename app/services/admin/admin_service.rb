module AdminService
  include BaseService
  module_function

  # Baseに記載する
  require 'open_stack'

  # キャッシュパス
  CACHE_CONTAINER_DATA_PATH = "#{Rails.root}#{Rails.application.config.common.cache[:conoha_container_data]}".freeze
  # オブジェクトストレージのコンフィグ
  CONOHA_OBS_CONF = Rails.application.config.api.conoha_object_strage.freeze

  def conoha_list
    if File.exist?(CACHE_CONTAINER_DATA_PATH)
      container_json = File.read(CACHE_CONTAINER_DATA_PATH).chomp
      container_data = JSON.parse(container_json, {:symbolize_names => true})
      file_stamp = File.mtime(CACHE_CONTAINER_DATA_PATH)
    else
      container_data = fetch_container_data
      File.open(CACHE_CONTAINER_DATA_PATH, "w"){|f| f.puts container_data.to_json }
      file_stamp = File.mtime(CACHE_CONTAINER_DATA_PATH)
    end

    [JsTreeDataMaker.make(container_data[:objects]), container_data[:metadata], file_stamp]
  end

  def delete_objects(file_paths)
    container = fetch_container_info
    ignore_objects = []
    no_exist_objects = []

    container_json = File.read(CACHE_CONTAINER_DATA_PATH).chomp
    cache_objects = JSON.parse(container_json, {:symbolize_names => true})[:objects]

    file_paths.each do |file_path|
      # キャッシュと整合性チェックする。
      # フォルダを削除しようとした際に不要なものが紛れる。しかし、表示の構成上、含まれてしまうため
      unless cache_objects.include? file_path
        ignore_objects << file_path
        next
      end

      # unless container.object_exists?(file_path)
      #   no_exist_objects << file_path
      #   next
      # end

      begin
        # 削除
        container.delete_object(file_path)
      rescue OpenStack::Exception::ItemNotFound => e
        # オブジェクトが存在しない
        no_exist_objects << file_path
      end

    end

    [no_exist_objects, ignore_objects]
  end

  def fetch_tree_datas_ajax
    container_data = fetch_container_data
    File.open(CACHE_CONTAINER_DATA_PATH, "w"){|f| f.puts container_data.to_json }

    [JsTreeDataMaker.make(container_data[:objects]), container_data[:metadata], File.mtime(CACHE_CONTAINER_DATA_PATH)]
  end

  def reset_tags_ajax
    `bundle exec rails analytics_lens:reset:add_tags RAILS_ENV=#{Rails.env}`

    0 == $?.exitstatus
  end

  def reset_word_ranking
    `bundle exec rails analytics_lens:reset:word_ranking RAILS_ENV=#{Rails.env}`

    0 == $?.exitstatus
  end

  # オブジェクトストレージの接続情報
  def fetch_container_data
    container = fetch_container_info
    container_metadata = container.container_metadata
    container_metadata[:name] = CONOHA_OBS_CONF[:container_name]
    container_data = {
      objects: container.objects,
      metadata: container_metadata,
    }
  end

  # オブジェクトストレージの接続情報
  def fetch_container_info
    os = OpenStack::Connection.create(
      username: CONOHA_OBS_CONF[:user_id],
      api_key: CONOHA_OBS_CONF[:password],
      authtenant_id: CONOHA_OBS_CONF[:tenant_id],
      auth_url: CONOHA_OBS_CONF[:auth_url],
      service_type: "object-store",
    )

    os.container(CONOHA_OBS_CONF[:container_name])
  end

  module JsTreeDataMaker extend self
    def make(tree_arry)
      tree = []
      folders = {"#"=> []}
      tree_arry.each do |path|
        # ルートを追加
        pn = Pathname.new("./#{path}")

        dirname = pn.dirname.to_s
        basename = pn.basename.to_s

        if folders.has_key? dirname
          set_data(pn, folders, tree)
        else
          re_make_folder(Pathname.new(pn), folders, tree)
        end
      end

      folders.each do |key, val|
        tree.each do |r|
          if r["id"] == key
            if val.size == 0
              r["text"] = "#{r["text"]}"
            else
              r["text"] = "#{r["text"]} (#{val.size})" 
            end
          end
        end
      end

      tree
    end

    # 再帰的に親フォルダを作成する
    def re_make_folder(pathname, folders, tree)
      # development*/lens-manage/production/DKC/DKC2/DKC3
      dirname = pathname.dirname.to_s
      # DKC_16150.jpg
      basename = pathname.basename.to_s

      # 親がルート
      # 再起終了
      if dirname == "."
        set_folder_data(pathname, folders, tree)
        return
      end

      # 親が存在する
      # 再起終了
      if folders.has_key? dirname
        # 自身を作成
        set_data(pathname, folders, tree)
      else
        # 自分を作成する
        # development*/lens-manage/production/DKC/DKC2/DKC3
        parent_dirname = set_new_data(pathname, folders, tree)

        # 親の親をも作成
        # development*/lens-manage/production/DKC/DKC2
        re_make_folder(Pathname.new(parent_dirname), folders, tree)
      end
    end

    def set_data(pathname, folders, tree)
      if File.extname(pathname.to_s) == "" # フォルダ
        set_folder_data(pathname, folders, tree)
      else
        set_file_data(pathname, folders, tree)
      end
    end

    def set_new_data(pn, folders, tree)
      dirname = pn.dirname.to_s == "." ? "#" : pn.dirname.to_s
      basename = pn.basename.to_s

      folders[dirname] = [basename]
      if File.extname(pn.to_s) == "" # フォルダ
        tree << { "id"=>pn.to_s, "parent"=>dirname, "text"=>basename, "icon"=>"jstree-folder" }
      else
        tree << { "id"=>pn.to_s, "parent"=>dirname, "text"=>basename, "icon"=>"jstree-file" }
      end
      dirname
    end

    def set_folder_data(pn, folders, tree)
      dirname = pn.dirname.to_s == "." ? "#" : pn.dirname.to_s
      basename = pn.basename.to_s

      # 以前に既に設定済み
      unless folders[dirname].include?(basename)
        folders[dirname] << basename
        tree << { "id"=>pn.to_s, "parent"=>dirname, "text"=>basename, "icon"=>"jstree-folder" }
      end
    end

    def set_file_data(pn, folders, tree)
      dirname = pn.dirname.to_s == "." ? "#" : pn.dirname.to_s
      basename = pn.basename.to_s

      folders[dirname] << basename
      tree << { "id"=>pn.to_s, "parent"=>dirname, "text"=>basename, "icon"=>"jstree-file" }
    end

    def safe_path_name(path_str)
      path_str.gsub(/\/|\.|\*|:|,|;|\?|"|<|>|\|/, '_')
    end
  end
end
