module Score
  extend ActiveSupport::Concern
  included do
    belongs_to :user, foreign_key: :uid
    field :s, as: :score, type: Integer
    field :cat, as: :created_at, type: DateTime
    field :uat, as: :updated_at, type: DateTime

    index({uid: 1}, {unique: true, name: 'uid_index'})
    index({s: -1}, {name: 'score_index'})
  end
end
