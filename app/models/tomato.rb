require "mongoid_tags"

class Tomato
  include Mongoid::Document
  include Mongoid::Document::Taggable
  include Mongoid::Timestamps
  
  belongs_to :user

  validate :must_not_overlap, :on => :create
  
  DURATION       = Rails.env.development? ? 10 : 25*60 # pomodoro default duration in seconds
  BREAK_DURATION = Rails.env.development? ? 5  : 5*60  # pomodoro default break duration in seconds
  
  include ActionView::Helpers::TextHelper
  include ApplicationHelper

  def must_not_overlap
    if last_tomato = user.tomatoes.where(:created_at => {'$gte' => Time.zone.now - DURATION.seconds}).order_by([[:created_at, :desc]]).first
      limit = (DURATION.seconds - (Time.zone.now - last_tomato.created_at)).seconds
      errors.add(:base, "Must not overlap saved tomaotes, please wait #{humanize(limit)}")
    end
  end

  def self.ranking_map(type)
    if :all_time != type
      date = Time.zone.now.send(beginning_of(type))
      date = "(new Date(#{date.year}, #{date.month-1}, #{date.day}))"
    end

    %Q{
      function() {
        emit(this.user_id, #{:all_time != type ? "this.created_at > #{date} ? 1 : 0" : 1});
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

  def self.ranking_collection(type)
    collection.map_reduce(ranking_map(type), ranking_reduce, {out: "user_ranking_#{type}s"})
  end

  def self.by_day(tomatoes)
    Range.new(tomatoes.keys.last.to_i, tomatoes.keys.first.to_i).step(60*60*24).map do |day|
      day = Time.at(day)
      [day.to_i*1000, tomatoes[day] ? tomatoes[day].size : 0]
    end
  end

  def self.by_hour(tomatoes)
    (0..23).map do |hour|
      millis = (Time.zone.now.beginning_of_day + hour*3600).to_i*1000
      [millis, tomatoes[hour] ? tomatoes[hour].size : 0]
    end
  end

  private

  def self.beginning_of(type)
    method = "beginning_of_"
    type = type.to_s

    case type
    when 'today'
      method << 'day'
    when 'this_week'
      method << 'week'
    when 'this_month'
      method << 'month'
    else
      method << type
    end
  end
end
