module UserSavedWorkoutsHelper
  def workout_saved?(workout)
    !!current_user.saved_workouts.exists?(workout.id)
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
