class UserRankingAllTime < UserRanking
  include Mongoid::Document

  field :value, type: Integer
  index(value: 1)
end
