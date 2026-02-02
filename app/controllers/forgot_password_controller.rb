class ForgotPasswordController < ApplicationController
  require "net/http"
  require "json"

  # GET /forgot_password
  def new
    # renders form where user enters their email
  end

  # POST /forgot_password
  def create
    email = params[:email]

    response = supabase_send_recover_email(email)

    if response["status"] == 200 || response["message"]&.include?("recovery email sent")
      redirect_to root_path, notice: "Odkaz na reset hesla byl odeslán na váš e-mail"
    else
      flash.now[:alert] = response["error_description"] || "Nepodařilo se odeslat odkaz na reset hesla"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def supabase_send_recover_email(email)
    uri = URI("#{ENV['SUPABASE_URL']}/auth/v1/recover")

    req = Net::HTTP::Post.new(uri)
    req["Content-Type"] = "application/json"
    req["apikey"] = ENV["SUPABASE_ANON_KEY"]

    req.body = { email: email }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    res = http.request(req)
    JSON.parse(res.body)
  rescue JSON::ParserError
    { "error_description" => "Chyba serveru" }
  end
end
