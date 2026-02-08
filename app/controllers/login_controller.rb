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

    if response && response["access_token"] && response["user"]

      session[:supabase_access_token] = response["access_token"]
      session[:supabase_user_id]    = response["user"]["id"]
      session[:supabase_user_email] = response["user"]["email"]

      redirect_to root_path, notice: "Přihlášení proběhlo úspěšně"
    else
      error_message = response&.dig("error_description") || response&.dig("error", "message") || "Nesprávné přihlašovací údaje"

      flash.now[:alert] = error_message
      render :new, status: :unprocessable_entity
    end

  rescue StandardError => e
    Rails.logger.error "Chyba při přihlášení: #{e.message}"
    flash.now[:alert] = "Nepodařilo se přihlásit. Zkuste to prosím znovu."
    render :new, status: :unprocessable_entity
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