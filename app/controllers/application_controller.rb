class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  before_action :set_time_zone

  protected

  def respond_with_json
    respond_to do |format|
      format.json { render json: yield }
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not found')
  end

  private

  def set_time_zone
    Time.zone = find_time_zone
  end

  def find_time_zone
    if current_user && current_user.time_zone && !current_user.time_zone.empty?
      current_user.time_zone
    else
      ActiveSupport::TimeZone[-cookies[:timezone].to_i.minutes]
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue Mongoid::Errors::DocumentNotFound
    nil
  end

  def same_user?
    @user ||= User.find(params[:id])
    current_user == @user
  end

  def same_user!
    redirect_to root_url, alert: 'Access denied' unless same_user?
  end

  def authenticate_user!
    redirect_to root_url, alert: 'You need to sign in' unless current_user
  end
end
