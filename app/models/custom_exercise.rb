class CustomExercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise

  validates :rep_range, presence: true
  validates :sets, presence: true

  def exercise_name
    self.exercise.name
  end
end
