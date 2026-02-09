# app/controllers/notes_controller.rb
class NotesController < ApplicationController
  before_action :logged_in? # use your Rails login

  def create
    heading = params[:heading]
    description = params[:description]

    if heading.blank?
      return render json: { success: false, error: "Název poznámky je povinný" }, status: :unprocessable_entity
    end

    # Insert into Supabase using service role key (server-side)
    supabase = Supabase::Client.new(ENV['SUPABASE_URL'], ENV['SUPABASE_SERVICE_KEY'])
    result = supabase.from('notes').insert([{ owner_id: current_user.id, heading: heading, description: description }])

    if result['error'].present?
      render json: { success: false, error: result['error']['message'] }, status: :unprocessable_entity
    else
      render json: { success: true, data: result['data'] }
    end
  rescue => e
    render json: { success: false, error: e.message }, status: :internal_server_error
  end
end