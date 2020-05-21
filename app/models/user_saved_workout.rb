class UserSavedWorkout < ApplicationRecord
  belongs_to :saved_workout, class_name: 'Workout'
  belongs_to :saved_user, class_name: 'User'
end
