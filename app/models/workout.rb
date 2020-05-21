class Workout < ApplicationRecord
  belongs_to :user
  has_many :user_saved_workouts, foreign_key: :saved_workout_id
  has_many :saved_users, through: :user_saved_workouts
end
