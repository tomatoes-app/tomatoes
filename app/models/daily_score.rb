class DailyScore
  include Mongoid::Document
  include Score
  include Expiring
end
