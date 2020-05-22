class UserSavedWorkoutsController < ApplicationController
  def create
    @workout = Workout.find_by(id: params[:workout_id])
    if @workout
      current_user.user_saved_workouts.create(workout: @workout)
      redirect_back(fallback_location: workouts_path)
    else
      redirect_back(fallback_location: workouts_path)
    end
  end
end
