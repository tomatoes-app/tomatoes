module Score
  extend ActiveSupport::Concern

  included do
    include Mongoid::Timestamps

    belongs_to :user, foreign_key: :uid, optional: true

    field :s, as: :score, type: Integer

    # Note: `Mongoid::Timestamps` module defines `created_at`, `updated_at`,
    # and callbacks to keep these fields up to date. `::fields` is a hash table
    # that contains document's fields. This is a similar approach used by
    # `Mongoid::Timestamps::Short` to define short names for timestamp fields.
    fields.delete('created_at')
    field :cat, as: :created_at, type: Time
    fields.delete('updated_at')
    field :uat, as: :updated_at, type: Time

    index({ uid: 1 }, unique: true, name: 'uid_index')
    index({ s: -1 }, name: 'score_index')
  end
end
