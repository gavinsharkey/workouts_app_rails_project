module WorkoutsHelper
  def workout_user_name(workout)
    workout.user.name
  end

  def current_users_workout?(workout)
    current_user.workouts.exists?(workout.id)
  end
end