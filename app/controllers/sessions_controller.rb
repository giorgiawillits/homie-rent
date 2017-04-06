# app/controllers/sessions_controller.rb
require 'pp'
class SessionsController < ApplicationController
  skip_before_filter :set_current_user

  def new
    if session[:user_id]
      redirect_to "/"
    end
    render :layout => "empty"
  end

  def create
    if env and env["omniauth.auth"]
      email = env["omniauth.auth"]["extra"]["raw_info"]['email']
      user = User.find_by_email(email)
      if user
        pp env["omniauth.auth"]
        user.provider = "facebook"
        user.uid = env["omniauth.auth"]["uid"]
        user.oauth_token = env["omniauth.auth"]["credentials"]["token"]
        user.oauth_expires_at = Time.at(env["omniauth.auth"]["credentials"]["expires_at"])
        user.save!
        # save the user id inside the browser cookie. This is how we keep the user logged in when they navigate around our website.
        session[:user_id] = user.id
        redirect_to '/'
        pp user
      else
        flash[:fb_redirect] = true
        flash[:warning] = "It does not look like you have an account yet. Please fill in the remaining info."
        flash[:first_name],flash[:last_name] = env["omniauth.auth"]["extra"]["raw_info"]["name"].split()
        flash[:email] = env["omniauth.auth"]["extra"]["raw_info"]["email"]
        print "*" * 100
        pp flash
        print "*" * 100
        redirect_to '/users/new'
      end
    else
      user = User.find_by_email(params[:email])
      if not user
        flash[:no_user] = "We could not find a user with the associated email. Please Try Again."
        redirect_to '/login'
      elsif not user.authenticate(params[:password])
        flash[:wrong_pw] = "Incorrect. Please try again."
        redirect_to '/login'
      else
        # save the user id inside the browser cookie. This is how we keep the user logged in when they navigate around our website.
        session[:user_id] = user.id
        redirect_to '/'
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end

  def failure
  end

end
