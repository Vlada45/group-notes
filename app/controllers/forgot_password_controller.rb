class ForgotPasswordController < ApplicationController
  require "net/http"
  require "json"
  require "uri"

  # GET /forgot_password
  def new
    # renders form where user enters their email
  end

  # POST /forgot_password
  def create
    supabase_send_recover_email(params[:email])

    # Always show the same message (security best practice)
    redirect_to login_path,
                notice: "Pokud e-mail existuje, byl odeslán odkaz pro obnovu hesla."
  end

  private

  # Send recovery email
  def supabase_send_recover_email(email)
    uri = URI("#{ENV['SUPABASE_URL']}/auth/v1/recover")

    req = Net::HTTP::Post.new(uri)
    req["Content-Type"] = "application/json"
    req["apikey"] = ENV["SUPABASE_ANON_KEY"]

    req.body = {
      email: email,
      redirect_to: "http://localhost:3000/password/reset"
    }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    res = http.request(req)
    Rails.logger.info "Supabase recover: #{res.code}"
  end
end