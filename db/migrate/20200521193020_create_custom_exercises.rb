class CreateCustomExercises < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_exercises do |t|
      t.belongs_to :workout
      t.belongs_to :exercise

      t.timestamps
    end
  end
end
