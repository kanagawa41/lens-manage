module AdminService
  # include BaseService
  module_function

  def conoha_list(tree_arry)
    to_jstree_json tree_arry
  end

  private

  # jstreeのdataに使用するjson文字列にして返却する
  #
  # production
  # production/DKC
  # production/DKC/DKC_16150.jpg
  # ↓　↓　↓　↓　↓
  #[
  # {"id"=>"production", "parent"=>"#", "text"=>"production(6)"},
  # {"id"=>"production_DKC", "parent"=>"production", "text"=>"DKC(10)"},
  # {"id"=>"f_DKC_16150.jpg", "parent"=>"production_DKC", "text"=>"DKC_16150.jpg"},
  def self.to_jstree_json(tree_arry)

    tree = []
    folders = {}
    tree_arry.each do |line|
      pn = Pathname.new(line)
      save_dirname = safe_path_name pn.dirname.to_s
      save_basename = safe_path_name pn.basename.to_s

      has_parent = folders.has_key? save_dirname
      if has_parent
        parent = save_dirname
      else
        parent = "#"
      end

      if File.extname(pn.to_s) == "" || pn.dirname.to_s == "." # フォルダ
        folders[save_dirname] << pn.basename.to_s if has_parent
        folders[safe_path_name(line.to_s)] = []
        file_data = { "id"=>safe_path_name(pn.to_s), "parent"=>parent, "text"=>pn.basename.to_s, "icon"=>"jstree-folder" }
      else # ファイル
        folders[save_dirname] << pn.basename.to_s if has_parent
        file_data = { "id"=>"#{parent}_f_#{save_basename}", "parent"=>parent, "text"=>pn.basename.to_s, "icon"=>"jstree-file" }
      end

      tree << file_data
    end

    # FIXME: パスを名前から導き出すので、数値を名前として表示できない。
    # folders.each do |key, val|
    #   tree.each do |r|
    #     if r["id"] == key
    #       if val.size == 0
    #         r["text"] = "#{r["text"]}"
    #       else
    #         r["text"] = "#{r["text"]}(#{val.size})" 
    #       end
    #     end
    #   end
    # end

    tree.to_json
  end

  def self.safe_path_name(path_str)
    path_str.gsub(/\/|\.|\*|:|,|;|\?|"|<|>|\|/, '_')
  end
end
