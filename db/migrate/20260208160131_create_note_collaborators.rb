class CreateNoteCollaborators < ActiveRecord::Migration[8.1]
  def change
    create_table :note_collaborators, id: false do |t|
      t.references :note, null: false, foreign_key: { on_delete: :cascade }
      t.references :user, null: false, foreign_key: { on_delete: :cascade }

      t.boolean :can_edit, default: false
      t.datetime :shared_at, default: -> { "CURRENT_TIMESTAMP" }
    end

    add_index :note_collaborators,
              [:note_id, :user_id],
              unique: true,
              name: "index_note_collaborators_pk"
  end
end
