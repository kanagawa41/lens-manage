require 'capybara/poltergeist'

namespace :fetch_lens_info do
  namespace :all do
    desc "ページ数を全て取得する"
    task page_num: :environment do
      TaskCommon::set_log 'fetch_lens_info/all/page_num'

      MShopInfo.select(:id, :shop_name).where(disabled: false).all.each do |m|
        Rails.logger.info "#{m.shop_name}のページ数を取得Fuck"
        # Rake::Task["fetch_lens_info:page_num"].invoke(m.id)
        `bundle exec rails fetch_lens_info:page_num[#{m.id}] RAILS_ENV=#{Rails.env}`
      end
    end

    desc "ページ情報を全て取得する"
    task page_info: :environment do
      TaskCommon::set_log 'fetch_lens_info/all/page_info'

      MShopInfo.select(:id, :shop_name).where(disabled: false).all.each do |m|
        Rails.logger.info "#{m.shop_name}のページ情報を取得"
        # Rake::Task["fetch_lens_info:page_info"].invoke(m.id)
        `bundle exec rails fetch_lens_info:page_info[#{m.id}] RAILS_ENV=#{Rails.env}`
      end
    end

    desc "画像を全て取得する"
    task lens_image: :environment do
      TaskCommon::set_log 'fetch_lens_info/all/lens_image'

      MShopInfo.select(:id, :shop_name).where(disabled: false).all.each do |m|
        Rails.logger.info "#{m.shop_name}の画像を取得"
        # Rake::Task["fetch_lens_info:lens_image"].invoke(m.id)
        `bundle exec rails fetch_lens_info:lens_image[#{m.id}] RAILS_ENV=#{Rails.env}`        
      end
    end
  end

  namespace :reset do
    desc "画像をリセットしたのち取得する"
    task :lens_image, ['target_shop_id'] => :environment do |task, args|
      shop_id = args[:target_shop_id].to_i
      MImage.joins(:m_lens_info).where('m_lens_infos.m_shop_info_id = ?', shop_id).delete_all
      # Rake::Task["fetch_lens_info:lens_image"].invoke(shop_id)      
      `bundle exec rails fetch_lens_info:lens_image[#{m.id}] RAILS_ENV=#{Rails.env}`        
    end
  end

  desc "ページ数を取得する"
  task :page_num, ['target_shop_id'] => :environment do |task, args|
    TaskCommon::set_log 'fetch_lens_info/page_num'

    TaskSwitchPageNum::fetch args[:target_shop_id].to_i
  end

  desc "ページ情報を取得する"
  task :page_info, ['target_shop_id'] => :environment do |task, args|
    TaskCommon::set_log 'fetch_lens_info/fetch_list'

    TaskSwitchPageInfo::fetch args[:target_shop_id].to_i
  end

  desc "画像を取得する"
  task :lens_image, ['target_shop_id'] => :environment do |task, args|
    TaskCommon::set_log 'fetch_lens_info/lens_image'

    m_shop_info = MShopInfo.find(args[:target_shop_id].to_i)
    # convert_image:masking と同期をとる
    work_dir = "#{Rails.application.config.common.images[:work_dir]}/#{m_shop_info.letter_code}"
    # オブジェクトストレージのパス
    objs_path = "#{Rails.env}#{Rails.application.config.common.images[:objs_path]}/#{m_shop_info.letter_code}"
    private_objs_path = "#{Rails.env}#{Rails.application.config.common.images[:private_container_name]}/#{m_shop_info.letter_code}"
    # オブジェクトストレージの接続情報
    conoha_obs_conf = Rails.application.config.api.conoha_object_strage
    os = OpenStack::Connection.create(
      username: conoha_obs_conf[:user_id],
      api_key: conoha_obs_conf[:password],
      authtenant_id: conoha_obs_conf[:tenant_id],
      auth_url: conoha_obs_conf[:auth_url],
      service_type: "object-store",
    )
    cont = os.container(conoha_obs_conf[:container_name])

    m_shop_info.m_lens_infos.all.each do |m_lens_info|
      next if ImageDownloadHistory.exists?(m_lens_info_id: m_lens_info.id)

      sleep [*2..5].sample # アクセスタイミングを分散させる

      begin
        maximum_id = ImageDownloadHistory.maximum(:id)
        next_id = maximum_id ? maximum_id + 1 : 1
        image_name = "#{m_shop_info.letter_code}_#{next_id}"
        image_path = "#{work_dir}/#{image_name}"

        image_path = HttpUtils::save_image(URI.unescape(m_lens_info.lens_pic_url), work_dir, image_name)
        image_name = File.basename(image_path)

        raise "#{image_name} :ファイル拡張子がなく画像ファイルでない可能性がある" unless File.extname(image_name).present?

        ImageDownloadHistory.new(m_shop_info_id: m_shop_info.id, m_lens_info_id: m_lens_info.id, lens_pic_url: m_lens_info.lens_pic_url, status: true).save!

        # 画像加工
        c_image_path = ConvertUtils::convert_image(image_path, "#{work_dir}/c", m_shop_info.shop_name, 'c_')

        image_chunk = File.open(image_path)
        new_obj = cont.create_object(
          "#{private_objs_path}/#{image_name}", 
          {
            content_type: MimeMagic.by_magic(image_chunk).type
          },
          image_chunk
        )
        c_image_chunk = File.open(c_image_path)
        new_obj = cont.create_object(
          "#{objs_path}/c/#{File.basename(c_image_path)}", 
          {
            content_type: MimeMagic.by_magic(c_image_chunk).type
          },
          c_image_chunk
        )

        MImage.new(m_lens_info_id: m_lens_info.id, path: image_name).save!
      rescue => e
        Rails.logger.error "#{e.message}"
        ImageDownloadHistory.new(m_shop_info_id: m_shop_info.id, m_lens_info_id: m_lens_info.id, lens_pic_url: m_lens_info.lens_pic_url, status: false).save
      end
    end

  end

end
