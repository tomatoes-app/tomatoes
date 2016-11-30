class UserRankingThisMonth < UserRanking
  include Mongoid::Document
  include Mongoid::Timestamps

  field :value, type: Integer
  index(value: 1)
end
