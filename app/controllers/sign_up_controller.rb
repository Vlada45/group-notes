class SignUpController < ApplicationController

  before_action :redirect_if_logged_in, only: [:new, :create]

  require "net/http"
  require "json"
  require "uri"

  def new
    # renders registration form
  end

  def create
    response = supabase_sign_up(params[:email], params[:password], params[:name])
    Rails.logger.debug "response: #{response.inspect}"

    if response["access_token"]
      # Supabase signup successful
      uid = response["user"]["id"]        # Supabase Auth ID
      email   = response["user"]["email"]
      username = params[:name]

    elsif response["error_code"] == "user_already_exists"
      Rails.logger.info "User already exists in Supabase Auth"

      uid = nil
      email = params[:email]
      username = params[:name]
    else
      flash.now[:alert] = response["error_description"] || response["msg"] || "Nastala chyba při registraci"
      render :new, status: :unprocessable_entity and return
    end

    # Insert into Rails users table if not already exists
    user = User.find_by(email: email)
    unless user
      user = User.create!(
        username: username,
        email: email,
        uid: uid
      )
    end

    # Set session
    session[:supabase_user_email] = user.email
    session[:supabase_user_id]    = user.id      # Rails numeric ID
    session[:supabase_uid]        = user.uid     # Supabase Auth ID
    session[:supabase_access_token] = response["access_token"] # JWT for REST requests

    redirect_to root_path, notice: "Registrace proběhla úspěšně"
  end

  private

  def supabase_sign_up(email, password, name)
    uri = URI("#{ENV['SUPABASE_URL']}/auth/v1/signup") # signup endpoint

    req = Net::HTTP::Post.new(uri)
    req["Content-Type"] = "application/json"
    req["apikey"] = ENV["SUPABASE_ANON_KEY"]

    req.body = {
      email: email,
      password: password,
      data: { name: name } # pass name as metadata
    }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    res = http.request(req)

    Rails.logger.debug "Supabase response body: #{res.body.inspect}"
    Rails.logger.debug "Status: #{res.code} #{res.message}"

    begin
      JSON.parse(res.body)
    rescue JSON::ParserError
      Rails.logger.error "Supabase vrátila neplatný JSON: #{res.body}"
      {}
    end
  end
end