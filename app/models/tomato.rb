require "mongoid_tags"

class Tomato
  include Mongoid::Document
  include Mongoid::Document::Taggable
  include Mongoid::Timestamps
  
  belongs_to :user
  
  DURATION       = Rails.env.development? ? 10 : 25*60 # pomodoro default duration in seconds
  BREAK_DURATION = Rails.env.development? ? 5  : 5*60  # pomodoro default break duration in seconds
  
  def self.sort_and_map(array)
    array.sort { |a, b| b['count'] <=> a['count'] }.map do |r|
      begin
        if r['user_id'] && user = User.find(r['user_id'])
          {:user => user, :count => r['count'].to_i}
        end
      rescue => e
        puts "ERROR: #{e}"
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
end
