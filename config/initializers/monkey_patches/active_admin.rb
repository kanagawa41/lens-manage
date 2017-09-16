###
# 参考: http://www.tom08.net/entry/2016/12/07/012130
# 作成理由: 出力されるCSVはUTF-8N(BOM付)で出力されるのを回避するため
###
module ActiveAdmin
  class CSVBuilder
    def encode(content, options)
      # Shift_JIS で出力する場合
      # content.to_s.encode("Windows-31J","UTF-8",invalid: :replace, undef: :replace).encode("UTF-8", "Windows-31J").encode("Windows-31J","UTF-8")
      content.to_s.encode("Windows-31J","UTF-8",invalid: :replace, undef: :replace).encode("UTF-8", "Windows-31J")
    end
  end
end