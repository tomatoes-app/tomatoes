class MonthlyScore
  include Mongoid::Document
  include Score
  include Expiring
end
