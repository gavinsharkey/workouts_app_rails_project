module UserSavedWorkoutsHelper
  def workout_saved?(workout)
    !!current_user.saved_workouts.exists?(workout.id)
  end
end
