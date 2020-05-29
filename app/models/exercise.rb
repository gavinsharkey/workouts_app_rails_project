class Exercise < ApplicationRecord
  has_many :custom_exercises, dependent: :destroy
  has_many :workouts, through: :custom_exercises
  
  scope :alphabetical, -> { order(:name) }
end