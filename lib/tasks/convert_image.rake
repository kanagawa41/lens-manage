namespace :convert_image do
  desc "画像をマスキングする"
  task :masking, ['target_shop_id'] => :environment do |task, args|
    m_shop_info = MShopInfo.find(args[:target_shop_id].to_i)
    dir = "/var/tmp/lens_infos/images/#{m_shop_info.id}/"
    m_shop_info.m_lens_infos.all.each do |m_lens_info|
      path = MImage.where(m_lens_info_id: m_lens_info.id).first[:path]

      ConvertUtils::convert_image(path, dir, m_shop_info.shop_name)
    end
  end
end

