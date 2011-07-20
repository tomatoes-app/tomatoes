require "mongoid_tags"

class Tomato
  include Mongoid::Document
  include Mongoid::Document::Taggable
  include Mongoid::Timestamps
  
  DURATION = 25*60 # pomodoro default duration in seconds
  
  belongs_to :user
end
