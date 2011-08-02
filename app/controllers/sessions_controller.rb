class SessionsController < ApplicationController
  def new
    redirect_to '/auth/github'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_omniauth(auth) || User.create_with_omniauth!(auth)
    user.update_omniauth_attributes!(auth)
    session[:user_id] = user.id
    
    logger.debug "auth hash: #{auth.inspect}"
    
    redirect_to root_url, :notice => 'Signed in!'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
end
