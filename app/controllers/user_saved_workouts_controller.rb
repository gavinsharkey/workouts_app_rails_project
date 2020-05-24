class UserSavedWorkoutsController < ApplicationController
  def new
    @workout = Workout.find_by(id: params[:workout_id])
    if @workout
      @saved_workout = @workout.user_saved_workouts.build
    else
      flash[:alert] = 'Workout does not exist'
      redirect_to workouts_path
    end
  end

  def create
    @workout = Workout.find_by(id: params[:workout_id])
    @saved_workout = current_user.user_saved_workouts.build(saved_workout: @workout, custom_title: saved_workout_params[:custom_title])

    if @saved_workout.save
      redirect_to workout_path(@workout)
    else
      render :new
    end
  end

  private

  def saved_workout_params
    params.require(:user_saved_workout).permit(:custom_title)
  end
end
