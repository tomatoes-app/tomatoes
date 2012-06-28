class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?
  
  before_filter :set_time_zone

  protected

  def destroy_resource(resource, redirect_url)
    resource.destroy

    respond_to do |format|
      format.html { redirect_to(redirect_url) }
      format.xml  { head :ok }
    end
  end

  def update_resource(resource)
    class_name = resource.class.to_s

    respond_to do |format|
      if resource.update_attributes(params[class_name.underscore.to_sym])
        format.html { redirect_to(resource, :notice => "#{class_name.titleize} was successfully updated.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => resource.errors, :status => :unprocessable_entity }
      end
    end
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
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to root_url, :alert => "Access denied."
    end
  end

  def authenticate_user!
    if !current_user
      redirect_to root_url, :alert => 'You need to sign in for access to this page.'
    end
  end
end
