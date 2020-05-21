module WorkoutsHelper
  def workout_user_name(workout)
    workout.user.name
  end
end