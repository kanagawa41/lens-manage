require 'open-uri'

class HttpUtils
  # 指定のURLから画像をダウンロードする
  # dirName: "/var/tmp/hoge/"
  # filename: ファイル名前(拡張子なし)
  def self.save_image(url, dir_name, filename=nil)
    image_name = File.basename(url)
    image_name = "#{filename}#{File.extname(image_name)}" if filename.present?
    image_path = "#{dir_name}/#{image_name}"

    FileUtils.mkdir_p(dir_name) unless FileTest.exist?(dir_name)
    # write image adata
    open(image_path, 'wb') do |output|
      open(url) do |data|
        output.write(data.read)
      end
    end

    image_path
  end
end