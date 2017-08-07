namespace :fetch_lens_info do
  # require 'capybara/poltergeist'

  desc "ページ数を取得する"
  task :page_num, ['target_shop_id'] => :environment do |task, args|
    TaskCommon::set_log 'collect_rends/page_num'

    TaskSwitchPageNum::fetch args[:target_shop_id].to_i
  end

  desc "ページ情報を取得する"
  task :page_info, ['target_shop_id'] => :environment do |task, args|
    TaskCommon::set_log 'collect_rends/fetch_list'

    TaskSwitchPageInfo::fetch args[:target_shop_id].to_i
  end

  desc "画像を取得する"
  task :lens_image, ['target_shop_id'] => :environment do |task, args|
    m_shop_info = MShopInfo.find(args[:target_shop_id].to_i)
    m_shop_info.m_lens_infos.all.each do |m_lens_info|
      next if MImage.exists?(m_lens_info_id: m_lens_info.id)

      sleep [*2..5].sample # アクセスタイミングを分散させる

      begin
        dir = "/var/tmp/lens_infos/images/#{m_shop_info.id}/"
        img_url = m_lens_info.lens_pic_url
        filename = HttpUtils::save_image(img_url, dir)

        ImageDownloadHistory.new(m_shop_info_id: m_shop_info.id, m_lens_info_id: m_lens_info.id, lens_pic_url: m_lens_info.lens_pic_url, status: true).save!
        MImage.new(m_lens_info_id: m_lens_info.id, path: "#{dir}#{filename}").save!
      rescue => e
        ImageDownloadHistory.new(m_shop_info_id: m_shop_info.id, m_lens_info_id: m_lens_info.id, lens_pic_url: m_lens_info.lens_pic_url, status: false).save
      end
    end

  end

end
