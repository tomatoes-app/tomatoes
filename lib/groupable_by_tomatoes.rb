require 'active_support/concern'

module GroupableByTomatoes
  extend ActiveSupport::Concern

  module ClassMethods
    def group_by_tomatoes(collection)
      Hash[collection.group_by do |item|
        item.tomatoes.count
      end.sort_by(&:first)]
    end
  end
end
