class Exercise < ApplicationRecord
  has_many :custom_exercises
  has_many :workouts, through: :custom_exercises, dependent: :destroy
end
