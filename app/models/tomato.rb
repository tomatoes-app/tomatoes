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

  DURATION       = Rails.env.development? ? 25 : 25 * 60 # pomodoro default duration in seconds
  BREAK_DURATION = Rails.env.development? ? 5  : 5 * 60  # pomodoro default break duration in seconds

  include ActionView::Helpers::TextHelper
  include ApplicationHelper

  class << self
    def ranking_map(time_period)
      if :all_time != time_period
        date = Time.zone.now.send(beginning_of(time_period))
        date = "(new Date(#{date.year}, #{date.month - 1}, #{date.day}))"
      end

      %{
        function() {
          emit(this.user_id, #{:all_time != time_period ? "this.created_at > #{date} ? 1 : 0" : 1});
        }
      }
    end

    def ranking_reduce
      %{
        function(key, values) {
          var result = 0;
          values.forEach(function(v) {
            result += v;
          });
          return result;
        }
      }
    end

    def ranking_collection(time_period)
      map_reduce(ranking_map(time_period), ranking_reduce).out(replace: "user_ranking_#{time_period}s").entries
    end

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
      tomatoes.collect(&:tags).flatten.inject(Hash.new(0)) do |hash, tag|
        hash[tag] += 1; hash
      end.sort { |a, b| b[1] <=> a[1] }
    end

    # CSV representation.
    def to_csv(tomatoes, opts = {})
      CSV.generate(opts) do |csv|
        tomatoes.each do |tomato|
          csv << [tomato.created_at, tomato.tags.join(', ')]
        end
      end
    end

    private

    def beginning_of(time_period)
      case time_period
      when :today
        'beginning_of_day'
      when :this_week
        'beginning_of_week'
      when :this_month
        'beginning_of_month'
      end
    end
  end

  def any_of_conditions
    tags.map { |tag| { tags: tag } }
  end

  def projects
    any_of_conditions.empty? ? [] : user.projects.any_of(any_of_conditions)
  end

  private

  def must_not_overlap
    last_tomato = user.tomatoes_after(Time.zone.now - DURATION.seconds).first
    if last_tomato
      limit = (DURATION.seconds - (Time.zone.now - last_tomato.created_at)).seconds
      errors.add(:base, "Must not overlap saved tomaotes, please wait #{humanize(limit)}")
    end
  end
end
