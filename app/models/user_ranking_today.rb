class UserRankingToday < UserRanking
  include Mongoid::Document
  index :value
end