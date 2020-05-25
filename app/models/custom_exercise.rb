class CustomExercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise

  def exercise_name
    self.exercise.name
  end
end
