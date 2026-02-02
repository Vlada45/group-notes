class LoginController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]

  require "net/http"
  require "json"
  require 'uri'

  def new
    # renders login form
  end

  def destroy
    # Remove all session data
    reset_session

    # Optionally, show a flash message
    redirect_to root_path, notice: "Odhlášeno úspěšně"

  end

  def create
    response = supabase_sign_in(params[:email], params[:password])

    if response["access_token"]
      session[:supabase_access_token] = response["access_token"] # optional
      session[:supabase_user_id] = response["user"]["id"]
      session[:supabase_user_email] = response["user"]["email"]

      Rails.logger.debug "DOBRA response: #{response.inspect}"

      redirect_to root_path, notice: "Přihlášení proběhlo úspěšně"
    else
      flash.now[:alert] = response["error_description"] || "Nesprávné přihlašovací údaje"

      render :new, status: :unprocessable_entity
    end
  end

  def supabase_sign_in(email, password)

    uri = URI("#{ENV['SUPABASE_URL']}/auth/v1/token?grant_type=password")

    req = Net::HTTP::Post.new(uri)
    req["Content-Type"] = "application/json"
    req["apikey"] = ENV["SUPABASE_ANON_KEY"]

    req.body = {
      email: email,
      password: password
    }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    res = http.request(req)
    JSON.parse(res.body)
  end
end