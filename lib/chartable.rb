module Chartable
  extend ActiveSupport::Concern
  include GroupableByDay

  ONE_DAY = 60*60*24

  module ClassMethods
    def to_lines(collection)
      collection_by_day = group_by_day(collection)
      days = collection_by_day.keys

      logger.debug "collection_by_day: #{collection_by_day.inspect}"

      Range.new(days.last.to_i, days.first.to_i).step(ONE_DAY).map do |day|
        day = Time.at(day)
        [day.to_i*1000, yield(collection_by_day[day])]
      end
    end
  end
end