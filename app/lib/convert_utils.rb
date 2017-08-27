class ConvertUtils
  FONT="#{Rails.root.to_s}#{Rails.application.config.common.images[:convert][:font_path]}"

  # 指定の画像にガウス加工と文字の挿入を行う
  # input_file_path: "/var/tmp/hoge/test.jpg"
  # output_dir: "/var/tmp/hoge/"
  def self.convert_image(input_file_path, output_dir, insert_str, name_prefix="")
    input_filename = File.basename(input_file_path)

    FileUtils.mkdir_p(output_dir)
    output_file_path = "#{output_dir}/#{name_prefix}#{input_filename}"

    raise "#{output_file_path}は既に存在します。" if File.exist?(output_file_path)

    # ガウス処理
    # gauss(input_file_path, output_file_path)

    # 文字挿入
    add_char(input_file_path, output_file_path, insert_str)

    output_file_path
  end

  private
  # ガウス処理
  def self.gauss(in_path, out_path)  
    message = `convert #{input_file_path} -blur 2x1 #{output_file_path} 2>&1`
    if message.size > 0
      raise "ガウス処理に失敗しました。: #{message}"
    end
  end

  # 文字挿入
  def self.add_char(in_path, out_path, insert_str)
    message = `convert -font #{FONT} -pointsize 30 -annotate +20x+0+50x+50 '#{insert_str}' -fill "#a9a9a9" #{in_path} #{out_path} 2>&1`
    if message.size > 0
      raise "文字挿入に失敗しました。: #{message}"
    end
  end
end