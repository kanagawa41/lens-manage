class HttpUtils
  # 指定のURLから画像をダウンロードする
  # dirName: "/var/tmp/hoge/"
  def self.save_image(url, dirName)
    fileName = File.basename(url)
    filePath = dirName + fileName

    FileUtils.mkdir_p(dirName) unless FileTest.exist?(dirName)

    # write image adata
    open(filePath, 'wb') do |output|
      open(url) do |data|
        output.write(data.read)
      end
    end

    fileName
  end
end