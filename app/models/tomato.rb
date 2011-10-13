require "mongoid_tags"

class Tomato
  include Mongoid::Document
  include Mongoid::Document::Taggable
  include Mongoid::Timestamps
  field :freckle_id, :type => String
  
  belongs_to :user
  
  DURATION       = Rails.env.development? ? 10 : 25*60 # pomodoro default duration in seconds
  BREAK_DURATION = Rails.env.development? ? 5  : 5*60  # pomodoro default break duration in seconds
  
  def to_freckle_entry
    {
      :entry => {
        :minutes => '25min',
        :date => created_at.strftime('%Y-%m-%d'),
        :description => tags.join(', '),
        :user => "#{user.freckle_login}@letsfreckle.com"
      }
    }
  end
  
  def self.to_freckle_set(tomatoes)
    tomatoes_array = []
    tomatoes.order_by([[:created_at, :desc]]).group_by do |tomato|
      date = tomato.created_at
      Time.mktime(date.year, date.month, date.day)
    end.each do |day, tomatoes|
      tomatoes.each do |tomato|
        tomatoes_array << tomato.to_freckle_entry
      end
    end
    
    tomatoes_array
  end
  
  def self.sort_limit_and_map(array)
    array.sort { |a, b| b['count'] <=> a['count'] }.slice(0, 10).map do |r|
      begin
        if r['user_id'] && user = User.find(r['user_id'])
          {:user => user, :count => r['count'].to_i}
        end
      rescue => e
        puts "ERROR: #{e}"
      end
    end.compact
  end
end
