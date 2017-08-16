class ConvertUtils
  FONT="#{Rails.root.to_s}/tmp/ipag.ttc"

  # 指定の画像にガウス加工と文字の挿入を行う
  # input_file_path: "/var/tmp/hoge/test.jpg"
  # output_dir: "/var/tmp/hoge/"
  def self.convert_image(input_file_path, output_dir, insert_str)
    input_filename = File.basename(input_file_path)
    output_file_path = "#{output_dir}c_#{input_filename}"

    return if File.exist?(output_file_path)

    # ガウス処理
    `convert #{input_file_path} -blur 2x1 #{output_file_path}`

    # 文字挿入
    `convert -font #{FONT} -pointsize 30 -annotate +20x+0+50x+50 '#{insert_str}' -fill "#a9a9a9" #{output_file_path} #{output_file_path}`
  end
end