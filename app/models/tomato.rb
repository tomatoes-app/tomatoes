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

  def self.sort_and_map(array)
    array.sort { |a, b| b['count'] <=> a['count'] }.map do |r|
      begin
        if r['user_id'] && user = User.find(r['user_id'])
          {:user => user, :count => r['count'].to_i}
        end
      rescue => e
        # puts "ERROR: #{e}"
      end
    end.compact
  end
  
  def self.ranking(opts = {})
    count_query_opts = {
      :key => :user_id,
      :initial => {:count => 0},
      :reduce => "function(doc, prev) {prev.count += 1}"
    }
    
    sort_and_map(collection.group(count_query_opts.merge(opts)))
  end
  
  def self.ranking_today
    ranking(:cond => {:created_at => {'$gt' => Time.zone.now.beginning_of_day.utc}})
  end
  
  def self.ranking_this_week
    ranking(:cond => {:created_at => {'$gt' => Time.zone.now.beginning_of_week.utc}})
  end
  
  def self.ranking_this_month
    ranking(:cond => {:created_at => {'$gt' => Time.zone.now.beginning_of_month.utc}})
  end

  def self.today
    collection.find(:cond => {:created_at => {'$gt' => Time.zone.now.beginning_of_day.utc}})
  end

  def self.this_week
    collection.find(:cond => {:created_at => {'$gt' => Time.zone.now.beginning_of_week.utc}})
  end

  def self.this_month
    collection.find(:cond => {:created_at => {'$gt' => Time.zone.now.beginning_of_month.utc}})
  end

  def self.all_time
    collection
  end

  def self.ranking_collection(collection, name)
    map = %Q{
      function() {
        emit(this.user_id, 1)
      }
    }

    reduce = %Q{
      function(key, values) {
        var result = 0;
        values.forEach(function(v) {
          result += v
        });
        return result;
      }
    }

    collection.map_reduce(map, reduce, {out: name})
  end
end
