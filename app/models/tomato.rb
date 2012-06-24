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
      date = Time.zone.now.send("beginning_of_#{type}")
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
end
