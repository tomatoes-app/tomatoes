class SessionsController < ApplicationController
  def new
    redirect_to '/auth/github'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth['provider'], :uid => auth['uid']).first || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    
    logger.debug "auth hash: #{auth.inspect}"
    
    # if !user.email
    #   redirect_to edit_user_path(user), :alert => "Please enter your email address."
    # else
    #   redirect_to root_url, :notice => 'Signed in!'
    # end
    
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
