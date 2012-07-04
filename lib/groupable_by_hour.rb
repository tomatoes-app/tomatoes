require 'active_support/concern'

module GroupableByHour
  extend ActiveSupport::Concern

  module ClassMethods
    def group_by_hour(collection)
      Hash[collection.group_by do |item|
        item.created_at.hour
      end.sort {|a, b| a[0] <=> b[0]}.map {|a| [a[0], a[1]]}]
    end
  end
end