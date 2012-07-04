class UserRankingThisMonth < UserRanking
  include Mongoid::Document
  index :value
end