module UserSavedWorkoutsHelper
  def workout_saved?(workout)
    !!current_user.saved_workouts.exists?(workout.id)
  end

  def current_users_saved_workout?(user_saved_workout)
    current_user.user_saved_workouts.exists?(user_saved_workout.id)
  end 

  def title(workout)
    workout.custom_title.blank? ? workout.saved_workout.name : workout.custom_title
  end

  def user_name(workout)
    workout.saved_workout.user.name
  end

  def saved_workout_description(workout)
    workout.saved_workout.description
  end
end
