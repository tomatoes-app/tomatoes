require 'active_support/concern'

module GroupableByHour
  extend ActiveSupport::Concern

  module ClassMethods
    def group_by_hour(collection)
      Hash[collection.group_by do |item|
        item.created_at.hour
      end.sort_by(&:first)]
    end
  end
end
