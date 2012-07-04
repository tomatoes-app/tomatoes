class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?
  
  before_filter :set_time_zone

  protected

  def respond_with_json
    respond_to do |format|
      format.json { render :json => yield }
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def set_time_zone
    Time.zone = (current_user && current_user.time_zone) || ActiveSupport::TimeZone[-cookies[:timezone].to_i.minutes]
  end
  
  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end
  end

  def user_signed_in?
    return true if current_user
  end

  def same_user?
    @user ||= User.find(params[:id])
    return current_user == @user
  end

  def same_user!
    redirect_to root_url, :alert => "Access denied." unless same_user?
  end

  def authenticate_user!
    redirect_to root_url, :alert => 'You need to sign in for access to this page.' unless current_user
  end
end
