# app/controllers/notes_controller.rb
class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy, :update_color]

  # GET /notes
  def index
    @notes = Note.all
  end

  # GET /notes/:id
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # POST /notes
  def create
    @note = Note.new(note_params)
    if @note.save
      redirect_to notes_path, notice: "Note created successfully!"
    else
      render :new
    end
  end

  # GET /notes/:id/edit
  def edit
  end

  # PATCH/PUT /notes/:id
  def update
    if @note.update(note_params)
      redirect_to notes_path, notice: "Note updated successfully!"
    else
      render :edit
    end
  end

  # DELETE /notes/:id
  def destroy
    @note.destroy
    redirect_to notes_path, notice: "Note deleted successfully!"
  end

  # PATCH /notes/:id/update_color
  def update_color
    @note = Note.find(params[:id])
    if @note.update(color: params[:color])
      # Pass both `note` and `color` explicitly
      render partial: "ui/components/card", locals: { note: @note, color: @note.color }
    else
      head :unprocessable_entity
    end
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    # Permit color if creating/updating via form
    params.require(:note).permit(:title, :content, :color)
  end
end