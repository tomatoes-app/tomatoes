module Expiring
  extend ActiveSupport::Concern
  included do
    field :eat, as: :expires_at, type: DateTime
    index({ eat: 1 }, { expire_after_seconds: 0, name: 'expiration_index' })
  end
end
