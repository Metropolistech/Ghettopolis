Dir["#{Rails.root.join('lib/extended/*.rb')}"].each do |f|
  require(f)
end
