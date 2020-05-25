class AddInstructionsToExercises < ActiveRecord::Migration[6.0]
  def change
    add_column :exercises, :instructions, :text
  end
end
