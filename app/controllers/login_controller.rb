class LoginController < ApplicationController
  def signIn
    # renders login form
  end

  def create
    email = params[:email]
    password = params[:password]

    response = SUPABASE_CLIENT.auth.sign_in(email, password) # anon key
    if response.error
      flash[:alert] = response.error.message
      redirect_to "home/index"
    else
      session[:access_token] = response.session.access_token
      redirect_to dashboard_path
    end
  end

  def destroy
    session[:access_token] = nil
    redirect_to root_path
  end
end
