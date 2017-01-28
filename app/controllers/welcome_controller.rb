class WelcomeController < ApplicationController
  layout 'welcome'

  before_action :new_tomato, if: :current_user
  before_action :daily_tomatoes, if: :current_user
  before_action :tomatoes_counters, if: :current_user
  before_action :daily_projects, if: :current_user

  def index
  end

  private

  def new_tomato
    @tomato = current_user.tomatoes.build
  end

  def daily_tomatoes
    @tomatoes ||= current_user.tomatoes.after(Time.zone.now.beginning_of_day)
  end

  def tomatoes_counters
    @tomatoes_count = current_user.tomatoes_counters
  end

  def daily_projects
    @projects = daily_tomatoes.collect(&:projects).flatten.uniq
  end
end
