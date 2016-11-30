class WeeklyScore
  include Mongoid::Document
  include Score
  include Expiring
end
