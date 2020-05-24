class UserSavedWorkoutsController < ApplicationController
  before_action :set_workout, only: [:new, :create, :edit]
  before_action :set_saved_workout, only: [:update, :destroy]

  def new
    if @workout
      @saved_workout = @workout.user_saved_workouts.build
    else
      flash[:alert] = 'Workout does not exist'
      redirect_to workouts_path
    end
  end

  def create
    @saved_workout = current_user.user_saved_workouts.build(saved_workout: @workout, custom_title: saved_workout_params[:custom_title])

    if @saved_workout.save
      redirect_to workout_path(@workout)
    else
      render :new
    end
  end

  def edit
    if @workout
      @saved_workout = @workout.user_saved_workouts.find_by(params[:id])
      if !@saved_workout
        flash[:alert] = 'Workout Not Saved'
        redirect_to user_path(current_user)
      end
    else
      flash[:alert] = 'Workout Not Found'
      redirect_to user_path(current_user)
    end
  end

  def update
    if @saved_workout.update(saved_workout_params)
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  def destroy
    @saved_workout.destroy
    redirect_to workout_path(params[:workout_id])
  end

  private

  def set_workout
    @workout = Workout.find_by(id: params[:workout_id])
  end

  def set_saved_workout
    @saved_workout = UserSavedWorkout.find_by(id: params[:id])
  end

  def saved_workout_params
    params.require(:user_saved_workout).permit(:custom_title)
  end
end
