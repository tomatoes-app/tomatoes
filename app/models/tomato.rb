require 'mongoid_tags'
require 'csv'

class Tomato
  include Mongoid::Document
  include Mongoid::Document::Taggable
  include Mongoid::Timestamps
  
  belongs_to :user

  index :created_at

  validate :must_not_overlap, :on => :create
  
  DURATION       = Rails.env.development? ? 10 : 25*60 # pomodoro default duration in seconds
  BREAK_DURATION = Rails.env.development? ? 5  : 5*60  # pomodoro default break duration in seconds
  
  include ActionView::Helpers::TextHelper
  include ApplicationHelper

  def must_not_overlap
    if last_tomato = user.tomatoes_after(Time.zone.now - DURATION.seconds).first
      limit = (DURATION.seconds - (Time.zone.now - last_tomato.created_at)).seconds
      errors.add(:base, "Must not overlap saved tomaotes, please wait #{humanize(limit)}")
    end
  end

  def self.ranking_map(time_period)
    if :all_time != time_period
      date = Time.zone.now.send(beginning_of(time_period))
      date = "(new Date(#{date.year}, #{date.month-1}, #{date.day}))"
    end

    %Q{
      function() {
        emit(this.user_id, #{:all_time != time_period ? "this.created_at > #{date} ? 1 : 0" : 1});
      }
    }
  end

  def self.ranking_reduce
    %Q{
      function(key, values) {
        var result = 0;
        values.forEach(function(v) {
          result += v;
        });
        return result;
      }
    }
  end

  def self.ranking_collection(time_period)
    collection.map_reduce(ranking_map(time_period), ranking_reduce, {out: "user_ranking_#{time_period}s"})
  end

  def self.group_by_day(tomatoes)
    tomatoes.order_by([[:created_at, :desc]]).group_by do |tomato|
      date = tomato.created_at
      Time.gm(date.year, date.month, date.day)
    end
  end

  def self.by_day(tomatoes)
    tomatoes = group_by_day(tomatoes)

    Range.new(tomatoes.keys.last.to_i, tomatoes.keys.first.to_i).step(60*60*24).map do |day|
      day = Time.at(day)
      [day.to_i*1000, tomatoes[day] ? tomatoes[day].size : 0]
    end
  end

  def self.by_hour(tomatoes)
    tomatoes = Hash[tomatoes.group_by do |tomato|
      now = Time.zone.now
      date = [2011, 1, 1, tomato.created_at.hour]
      Time.gm(*date)
    end.sort {|a, b| a[0].hour <=> b[0].hour}.map {|a| [a[0].hour, a[1]]}]

    (0..23).map do |hour|
      millis = (Time.zone.now.beginning_of_day + hour*3600).to_i*1000
      [millis, tomatoes[hour] ? tomatoes[hour].size : 0]
    end
  end

  # CSV representation.
  def self.to_csv(tomatoes)
    CSV.generate do |csv| 
      tomatoes.each do |tomato|
        csv << [tomato.created_at, tomato.tags.join(", ")]
      end
    end
  end

  private

  def self.beginning_of(time_period)
    case time_period
    when :today
      'beginning_of_day'
    when :this_week
      'beginning_of_week'
    when :this_month
      'beginning_of_month'
    end
  end
end
