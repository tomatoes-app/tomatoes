require 'mongoid_tags'
require 'csv'

class Tomato
  include Mongoid::Document
  include Mongoid::Document::Taggable
  include Mongoid::Timestamps
  include Chartable

  belongs_to :user

  index(created_at: 1)

  validate :must_not_overlap, on: :create

  after_create :increment_score
  after_destroy :decrement_score

  DURATION       = Rails.env.development? ? 25 : 25 * 60 # pomodoro default duration in seconds
  BREAK_DURATION = Rails.env.development? ? 5  : 5 * 60  # pomodoro default break duration in seconds

  include ActionView::Helpers::TextHelper
  include ApplicationHelper

  scope :before, ->(time) { where(:created_at.lt => time) }
  scope :after, ->(time) { where(:created_at.gte => time) }

  class << self
    def by_day(tomatoes)
      to_lines(tomatoes) do |tomatoes_by_day|
        yield(tomatoes_by_day)
      end
    end

    def by_hour(tomatoes)
      to_hours_bars(tomatoes) do |tomatoes_by_hour|
        yield(tomatoes_by_hour)
      end
    end

    def by_tags(tomatoes)
      tomatoes
        .map(&:tags)
        .flatten
        .group_by(&:itself)
        .map { |tag, tags| [tag, tags.size] }
        .sort { |a, b| b[1] <=> a[1] }
    end

    # CSV representation.
    def to_csv(tomatoes, opts = {})
      CSV.generate(opts) do |csv|
        tomatoes.each do |tomato|
          csv << [tomato.created_at, tomato.tags.join(', ')]
        end
      end
    end
  end

  def projects
    user.projects.tagged_with(tags)
  end

  private

  def must_not_overlap
    last_tomato = user.tomatoes.after(Time.zone.now - DURATION.seconds).order_by([%i[created_at desc]]).first
    return unless last_tomato
    limit = (DURATION.seconds - (Time.zone.now - last_tomato.created_at)).seconds
    errors.add(:base, I18n.t('errors.messages.must_not_overlap', limit: humanize(limit)))
  end

  def increment_score
    IncrementScoreJob.perform_async(user_id)
  end

  def decrement_score
    IncrementScoreJob.perform_async(user_id, -1)
  end
end
