class UserRankingAllTime < UserRanking
  include Mongoid::Document
  index :value
end