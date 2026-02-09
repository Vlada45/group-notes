class NotesController < ApplicationController
  require "net/http"
  require "json"
  require "uri"

  # def index
  #   Rails.logger.info "Session data: #{session.inspect}"
  #
  #   # Supabase UID from session
  #   user_uid = current_user[:id]
  #   Rails.logger.info "Looking up user with UID: #{current_user[:id]}"
  #
  #   # Rails user by uid column
  #   user = User.find_by(uid: user_uid)
  #   Rails.logger.info "Found user: #{user.inspect}"
  #
  #   @notes = user ? Note.where(user_id: user.id).order(created_at: :desc) : Note.none
  #   Rails.logger.info "Notes loaded: #{@notes.inspect}"
  # end

  def create
    heading = params[:heading]
    description = params[:description]

    # Find Rails user by Supabase UID stored in session
    user = User.find_by(uid: current_user[:id]) || User.find_by(uid: session[:supabase_uid])

    unless user
      flash[:alert] = "Uživatel nebyl nalezen v naší databázi"
      redirect_to root_path and return
    end

    # Ensure the Supabase access token exists
    jwt = session[:supabase_access_token]
    unless jwt.present?
      flash[:alert] = "Uživatel není přihlášen v Supabase"
      redirect_to root_path and return
    end

    Rails.logger.info "Adding note for UID: #{user.id} | Heading: #{heading} | Description: #{description}"

    # Prepare the REST request to Supabase
    uri = URI("#{ENV['SUPABASE_URL']}/rest/v1/notes")
    req = Net::HTTP::Post.new(uri)
    req["Content-Type"] = "application/json"
    req["apikey"] = ENV["SUPABASE_ANON_KEY"]
    req["Authorization"] = "Bearer #{jwt}"

    now = Time.now.utc.iso8601

    # Send the correct user_id (Supabase UID)
    req.body = { user_id: user.id, heading: heading, description: description, created_at: now,
                 updated_at: now, starred: false, color: "yellow" }.to_json

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }

    Rails.logger.info "Supabase response: #{res.code} | #{res.body}"

    res_hash = JSON.parse(res.body.presence || "{}")

    if res_hash["error"].present?
      flash[:alert] = "Nepodařilo se přidat poznámku: #{res_hash['error']}"
    else
      flash[:notice] = "Poznámka byla úspěšně přidána!"
    end

    redirect_to root_path
  end
end
