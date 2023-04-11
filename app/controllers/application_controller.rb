class ApplicationController < ActionController::Base
  add_flash_types(:danger)

  private 

  def current_user 
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_user?(user)
    current_user = user 
  end

  def require_signin
    unless current_user
      session[:intended_url] = request.url 
      redirect_to new_session_url, notice: "Please sign in first."
    end
  end

  helper_method :current_user 
  helper_method :current_user?
end
