require 'mongoid_tags'

class Project
  include Mongoid::Document
  include Mongoid::Document::Taggable
  include Mongoid::Timestamps

  field :name,        :type => String
  field :budget,      :type => Integer
  field :time_budget, :type => Integer

  belongs_to :user

  validates_presence_of :name
end
