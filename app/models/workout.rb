class Workout < ApplicationRecord
  belongs_to :user

  has_many :user_saved_workouts, foreign_key: :saved_workout_id
  has_many :saved_users, through: :user_saved_workouts

  has_many :custom_exercises
  has_many :exercises, through: :custom_exercises, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true

  accepts_nested_attributes_for :custom_exercises, reject_if: proc { |attrs| attrs['exercise_id'].blank? }
end
