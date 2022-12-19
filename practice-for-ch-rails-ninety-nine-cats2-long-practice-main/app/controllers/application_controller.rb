class ApplicationController < ActionController::Base

   helper method :current_user

   def current_user
      @current_user ||= User.find_by(session_token: session[:session_token])
   end

   # def logged_in?
   #    !!current_user
   # end
end