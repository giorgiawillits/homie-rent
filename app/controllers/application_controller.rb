# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :set_current_user
  protected # prevents method from being invoked by a route
  def set_current_user
    current_user
    authorize
  end
  
  def current_user
    # we exploit the fact that find_by_id(nil) returns nil
    @current_user ||= User.find_by_id(session[:user_id])
    if not @current_user
      session[:user_id] = nil
    end
    return @current_user
  end
  helper_method :current_user

  def authorize
    redirect_to login_path and return unless @current_user
  end
  
  def current_house
    if current_user
      current_user.house
    end
  end
  helper_method :current_house
  
  def current_house_members
    if current_user
      User.where(:house => current_user.house)
    end
  end
  helper_method :current_house_members
end
