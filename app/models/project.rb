require 'mongoid_tags'

class Project
  include Mongoid::Document
  include Mongoid::Document::Taggable
  include Mongoid::Timestamps
  include Workable

  field :name,         type: String
  field :money_budget, type: Integer
  field :time_budget,  type: Integer

  belongs_to :user, optional: true

  validates :name, presence: true
  validates :money_budget, numericality: { greater_than: 0, allow_blank: true }
  validates :time_budget, numericality: { greater_than: 0, allow_blank: true }

  def estimated_work_time
    (time_budget.to_i * 60 * 60 * Workable::WORK_TIME_FACTOR if time_budget).to_i
  end

  def estimated_hourly_rate
    money_budget.to_f / (estimated_work_time / 60 / 60).to_f if money_budget && estimated_work_time
  end

  def tomatoes
    user.tomatoes.tagged_with(tags)
  end

  def effective_hourly_rate
    money_budget.to_f / (effective_work_time * 60 * 60).to_f if money_budget
  end

  def hourly_rate_delta
    effective_hourly_rate.to_f - estimated_hourly_rate.to_f
  end

  def work_time_delta
    effective_work_time - estimated_work_time
  end
end
