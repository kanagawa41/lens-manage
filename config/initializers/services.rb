Rails.application.config.to_prepare do
  Dir.glob("app/services/concerns/*.rb") do |f|
    require_dependency Rails.root.join(f)
  end

  Dir.glob("app/services/**/*.rb") do |f|
    require_dependency Rails.root.join(f)
  end
end
