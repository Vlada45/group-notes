class AddColorToNotes < ActiveRecord::Migration[8.1]
  def change
    add_column :notes, :color, :string, null: false
  end
end
