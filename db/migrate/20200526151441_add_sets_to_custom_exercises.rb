class AddSetsToCustomExercises < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_exercises, :sets, :integer
  end
end
