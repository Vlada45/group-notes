class ApplicationController < ActionController::Base
  require 'jwt'

  before_action :check_supabase_jwt

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?

  private

  # Get the current user from session
  def current_user
    return unless session[:supabase_user_id]

    # Fetch full user data from Supabase
    { id: session[:supabase_user_id], email: session[:supabase_user_email] }
  end

  # Check if user is logged in
  def logged_in?
    current_user.present?
  end

  # Redirect logged-in users away from login/signup pages
  def redirect_if_logged_in
    if logged_in?
      redirect_to root_path, alert: "Jste již přihlášen"
    end
  end

  # Checks current user JWT token
  def check_supabase_jwt
    jwt = session[:supabase_access_token]

    return unless jwt.present?

    begin
      payload, _header = JWT.decode(jwt, nil, false)

      exp = payload["exp"]
      if Time.at(exp) < Time.now

        reset_session
        redirect_to root_path, alert: "Vaše relace vypršela. Prosím, přihlaste se znovu."
      end

    rescue JWT::DecodeError

      reset_session
      redirect_to root_path, alert: "Neplatná relace. Prosím, přihlaste se znovu."
    end
  end

end
