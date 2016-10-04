require 'active_support/concern'

module GroupableByDay
  extend ActiveSupport::Concern

  module ClassMethods
    def group_by_day(collection)
      collection.order_by([[:created_at, :desc]]).group_by do |resource|
        date = resource.created_at
        Time.gm(date.year, date.month, date.day) if date
      end
    end
  end
end
