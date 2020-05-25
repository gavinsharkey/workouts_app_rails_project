class AddRepRangeToCustomExercises < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_exercises, :rep_range, :string
  end
end
