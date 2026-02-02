class SignUpController < ApplicationController

  before_action :redirect_if_logged_in, only: [:new, :create]

  require "net/http"
  require "json"
  require 'uri'

  def new
    # renders registration form
  end

  def create
    response = supabase_sign_up(params[:email], params[:password], params[:name])

    Rails.logger.debug "respone: #{response}"

    if response["access_token"]
      session[:supabase_access_token] = response["access_token"] # optional
      session[:supabase_user_id] = response["user"]["id"]
      session[:supabase_user_email] = response["user"]["email"]

      redirect_to root_path, notice: "Registrace proběhla úspěšně"
    else
      flash.now[:alert] = response["error_description"] || "Nastala chyba při registraci"
      render :new, status: :unprocessable_entity
    end
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