require 'mongoid_tags'

class Project
  include Mongoid::Document
  include Mongoid::Document::Taggable
  include Mongoid::Timestamps

  TOMATO_TIME_FACTOR   = (Tomato::DURATION*4 + Tomato::BREAK_DURATION*(3+3))/(Tomato::DURATION*4).to_f
  HOURS_PER_DAY_FACTOR = 24/8.0
  DAYS_PER_WEEK_FACTOR = 7/5.0
  WORK_TIME_FACTOR     = DAYS_PER_WEEK_FACTOR * HOURS_PER_DAY_FACTOR * TOMATO_TIME_FACTOR

  field :name,         :type => String
  field :money_budget, :type => Integer
  field :time_budget,  :type => Integer

  belongs_to :user

  validates_presence_of :name

  def estimated_work_time
    time_budget * WORK_TIME_FACTOR if time_budget
  end

  def estimated_hourly_rate
    money_budget / estimated_work_time*60*60 if money_budget && estimated_work_time
  end

  def any_of_conditions
    tags.map { |tag| {tags: tag} }
  end

  def tomatoes
    user.tomatoes.any_of(any_of_conditions)
  end

  def work_time
    (tomatoes.count * Tomato::DURATION)*60
  end

  def effective_work_time
    work_time * Project::WORK_TIME_FACTOR
  end

  def effective_hourly_rate
    money_budget / effective_work_time*60*60 if money_budget
  end
end
