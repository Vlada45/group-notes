class ApplicationController < ActionController::Base
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

end
