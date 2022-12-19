class SessionsController < ApplicationController

    def new
        @user = User.new
        render :new
    end

    def create
       username = params[:user][:username]
       password = params[:user][:password]
       @user = User.find_by_credentials(username, password)

       if @user
            redirect_to cats_url
       else
            redirect_to new_session_url
       end
    end

    def destroy
      if current_user != nil
         current_user.reset_session_token!
      end
      session[:session_token] = nil
      current_user = nil
    end

end
