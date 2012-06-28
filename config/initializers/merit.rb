# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  # config.checks_on_each_request = true

  # Define ORM. Could be :active_record (default) and :mongo_mapper and :mongoid
  config.orm = :mongoid
end

# Create application badges (uses https://github.com/norman/ambry)
(1..5).map do |n|
  {
    :id          => n,
    :name        => 'tomatoer',
    :level       => n,
    :description => "#{ActiveSupport::Inflector::ordinalize(10**(n-1))} tomato",
    :image       => "tomatoer_level_#{n}.png"
  }
end.each do |badge|
  Badge.create! badge
end

(1..10).map do |n|
  {
    :id          => n+5,
    :name        => 'diligent_tomatoer',
    :level       => n,
    :description => "#{4*n} tomatoes in a row",
    :image       => "diligent_tomatoer_level_#{n}.png"
  }
end.each do |badge|
  Badge.create! badge
end

(1..10).map do |n|
  {
    :id          => n+5+10,
    :name        => 'assiduous_tomatoer',
    :level       => n,
    :description => "#{ActiveSupport::Inflector::ordinalize(2**n)} days with tomatoes in a row",
    :image       => "assiduous_tomatoer_level_#{n}.png"
  }
end.each do |badge|
  Badge.create! badge
end