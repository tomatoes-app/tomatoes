class UserRankingThisWeek < UserRanking
  include Mongoid::Document
  index :value
end