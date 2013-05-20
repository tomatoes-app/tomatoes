module Chartable
  extend ActiveSupport::Concern
  include GroupableByDay
  include GroupableByHour
  include GroupableByTomatoes

  ONE_DAY = 60*60*24

  module ClassMethods
    def to_lines(collection)
      collection_by_day = group_by_day(collection)
      days = collection_by_day.keys

      Range.new(days.last.to_i, days.first.to_i).step(ONE_DAY).map do |day|
        day = Time.at(day)
        [day.to_i*1000, yield(collection_by_day[day])]
      end
    end

    def to_hours_bars(collection)
      collection_by_hour = group_by_hour(collection)

      (0..23).map do |hour|
        millis = (Time.zone.now.beginning_of_day + hour*3600).to_i*1000
        [millis, yield(collection_by_hour[hour])]
      end
    end

    def to_tomatoes_bars(collection)
      collection_by_tomatoes = group_by_tomatoes(collection)
      tomatoes = collection_by_tomatoes.keys

      Range.new(tomatoes.first || 0, tomatoes.last || 0).map do |tomatoes_count|
        [tomatoes_count, yield(collection_by_tomatoes[tomatoes_count])]
      end
    end
  end
end