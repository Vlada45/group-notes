class HomeController < ApplicationController
  def index

    if logged_in?
      Rails.logger.info "Session data: #{session.inspect}"

      # Supabase UID from session
      user_uid = current_user[:id]
      Rails.logger.info "Looking up user with UID: #{current_user[:id]}"

      # Rails user by uid column
      user = User.find_by(uid: user_uid)
      Rails.logger.info "Found user: #{user.inspect}"

      @notes = user ? Note.where(user_id: user.id).order(created_at: :desc) : Note.none
      Rails.logger.info "Notes loaded: #{@notes.inspect}"
    end
  end
end
