class HomeController < ApplicationController

  # GET /
  def index
    return unless logged_in?
    Rails.logger.info "Session data: #{session.inspect}"

    # Supabase UID from session
    user_uid = current_user[:id]
    Rails.logger.info "Looking up user with UID: #{current_user[:id]}"

    # Rails user by uid column
    user = User.find_by(uid: user_uid)
    Rails.logger.info "Found user: #{user.inspect}"

    @notes = user ? Note.where(user_id: user.id) : Note.none
    Rails.logger.info "Notes loaded: #{@notes.inspect}"

    # Only headings that start with the search string
    if params[:search].present?
      @notes = @notes.where("heading ILIKE ?", "#{params[:search]}%")
    end
    # Sort notes
    @notes = sort_notes(@notes, params[:sort])
  end

  private

  # Sort Notes by selection
  def sort_notes(notes, sort_param)
    Rails.logger.debug "Final SQL: #{@notes.to_sql}"
    Rails.logger.debug "Sort param: #{sort_param}"
    case sort_param
    when "heading"
      notes.order(:heading)
    when "created_at"
      notes.order(created_at: :desc)
    when "updated_at"
      notes.order(updated_at: :desc)
    else
      notes.order(created_at: :desc)
    end
  end
end
