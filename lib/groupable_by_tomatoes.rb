require 'active_support/concern'

module GroupableByTomatoes
  extend ActiveSupport::Concern

  module ClassMethods
    def group_by_tomatoes(collection)
      Hash[collection.group_by do |item|
        item.tomatoes.count
      end.sort {|a, b| a[0] <=> b[0]}.map {|a| [a[0], a[1]]}]
    end
  end
end