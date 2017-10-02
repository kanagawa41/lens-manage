module AdminService
  # include BaseService
  module_function

  def conoha_list(tree_arry)
    TreeMaker.make tree_arry
  end

  private

  module TreeMaker extend self
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
