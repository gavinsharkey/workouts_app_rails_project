class UserSavedWorkout < ApplicationRecord
  belongs_to :saved_workout, class_name: 'Workout'
  belongs_to :saved_user, class_name: 'User'

  def title
    self.custom_title.blank? ? self.saved_workout.name : self.custom_title
  end

  def user_name
    self.saved_workout.user.name
  end

  def saved_workout_description
    self.saved_workout.description
  end
end
