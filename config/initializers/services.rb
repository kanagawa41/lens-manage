Rails.application.config.to_prepare do
  require_dependency Rails.root.join('app/services/base_service')

  Dir.glob("app/services/**/*.rb") do |f|
    require_dependency Rails.root.join(f)
  end
end
