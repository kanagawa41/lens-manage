namespace :convert_image do

  namespace :all do
    # オブジェクトストレージに対応していないため自前でフォルダに展開する必要がある
    desc "全ての画像をマスキングする"
    task masking: :environment do
      TaskCommon::set_log 'convert_image/all/masking'

      MShopInfo.select(:id, :shop_name).where(disabled: true).all.each do |m|
        Rails.logger.info "#{m.shop_name}のページ数を取得"
        Rake::Task["convert_image:masking"].invoke(m.id)
      end
    end
  end

  # オブジェクトストレージに対応していないため自前でフォルダに展開する必要がある
  desc "画像をマスキングする"
  task :masking, ['target_shop_id'] => :environment do |task, args|
    TaskCommon::set_log 'convert_image/masking'

    m_shop_info = MShopInfo.find(args[:target_shop_id].to_i)
    dir = "#{Rails.application.config.common.images[:work_dir]}/#{m_shop_info.letter_code}"

    m_shop_info.m_lens_infos.all.each do |m_lens_info|
      m_image = MImage.where(m_lens_info_id: m_lens_info.id).first
      next unless m_image.present?

      path = m_image[:path]

      begin
        ConvertUtils::convert_image("#{dir}/#{path}", "#{dir}/c", m_shop_info.shop_name, 'c_') if path.present?
      rescue => e
        Rails.logger.info "#{path}: #{e.message}"
      end
    end
  end
end

