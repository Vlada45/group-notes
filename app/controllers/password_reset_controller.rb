class PasswordResetController < ApplicationController
  before_action :redirect_if_logged_in, only: [:edit, :update]

  require "net/http"
  require "json"
  require "uri"

  # GET /password/reset
  def edit
    @access_token = params[:access_token]

    unless @access_token.present?
      redirect_to login_path, alert: "Neplatný nebo expirovaný odkaz"
    end

  end

  # PATCH /password/reset
  def update
    response = supabase_update_password(
      params[:access_token],
      params[:password]
    )

    if response["error"].blank?
      redirect_to login_path, notice: "Heslo bylo úspěšně změněno"
    else
      flash.now[:alert] = "Změna hesla se nezdařila"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Update password using recovery access token
  def supabase_update_password(access_token, password)
    uri = URI("#{ENV['SUPABASE_URL']}/auth/v1/user")

    req = Net::HTTP::Put.new(uri)
    req["Content-Type"] = "application/json"
    req["Authorization"] = "Bearer #{access_token}"
    req["apikey"] = ENV["SUPABASE_ANON_KEY"]

    req.body = { password: password }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    res = http.request(req)

    Rails.logger.info "Supabase update password: #{res.code} | body: #{res.body}"

    res_hash = JSON.parse(res.body) rescue { "error" => { "message" => "invalid_response" } }

    if res_hash['error'].present? && !res_hash['error'].is_a?(Hash)
      res_hash['error'] = { 'message' => res_hash['error'].to_s }
    end

    res_hash
  rescue StandardError => e
    Rails.logger.error "Error updating Supabase password: #{e.message}"
    { "error" => { "message" => "internal_error" } }
  end

end