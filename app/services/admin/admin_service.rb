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
      save_dirname = pn.dirname.to_s.gsub(/\//, '_')
      save_basename = pn.basename.to_s.gsub(/\//, '_')

      has_parent = folders.has_key? save_dirname
      if has_parent
        parent = save_dirname
      else
        parent = "#"
      end

      if File.extname(pn.to_s) == "" || pn.dirname.to_s == "." # フォルダ
        folders[save_dirname] << pn.basename.to_s if has_parent
        folders[line.to_s.gsub(/\//, '_')] = []
        file_data = { "id"=>pn.to_s.gsub(/\//, '_'), "parent"=>parent, "text"=>pn.basename.to_s, "icon"=>"jstree-folder" }
      else # ファイル
        folders[save_dirname] << pn.basename.to_s if has_parent
        file_data = { "id"=>"f_#{save_basename}", "parent"=>parent, "text"=>pn.basename.to_s, "icon"=>"jstree-file" }
      end

      tree << file_data
    end

    folders.each do |key, val|
      tree.each do |r|
        if r["id"] == key
          if val.size == 0
            r["text"] = "#{r["text"]}"
          else
            r["text"] = "#{r["text"]}(#{val.size})" 
          end
        end
      end
    end

    tree.to_json
  end

end
