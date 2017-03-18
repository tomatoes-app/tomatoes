class ApplicationController < ActionController::Base
  include HttpAcceptLanguage::AutoLocale

  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :page_title
  helper_method :page_description

  before_action :set_time_zone
  before_action :set_locale

  protected

  def respond_with_json
    respond_to do |format|
      format.json { render json: yield }
    end
  end

  private

  def set_time_zone
    Time.zone = find_time_zone
  rescue ArgumentError => e
    logger.error "Argument error: #{e}"
    Time.zone = Rails.configuration.time_zone
  end

  def find_time_zone
    current_user.try(:time_zone) ||
      ActiveSupport::TimeZone[-cookies[:timezone].to_i.minutes]
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

  def page_title
    @page_title ||= I18n.t('app_name')
  end

  def page_description
    @page_description ||= I18n.t('default_description')
  end
end
