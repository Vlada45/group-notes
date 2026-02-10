class NotesController < ApplicationController

  before_action :set_note, only: [:update, :destroy]

  require "net/http"
  require "json"
  require "uri"

  # POST /notes
  def create
    heading = params[:heading]
    description = params[:description]
    color = params[:color]

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
                 updated_at: now, starred: false, color: color }.to_json

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

  # PATCH /notes/:id
  def update
    if @note.update(note_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path, notice: "Poznámka byla aktualizována" }
      end
    else
      head :unprocessable_entity
    end
  end


  # DELETE /notes/:id
  def destroy
    @note.destroy
    respond_to do |format|
      format.turbo_stream  # destroy.turbo_stream.erb
      format.html { redirect_to root_path, notice: "Poznámka smazána" }
    end
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:heading, :description, :color)
  end

end
