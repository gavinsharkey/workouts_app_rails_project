class WorkoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout, only: [:show]

  def index
    if params[:user_id]
      @user = User.find_by(id: params[:user_id])
      redirect_to workouts_path if !@user
      @workouts = @user.workouts
    else
      @workouts = Workout.all
    end
  end

  def new
    @exercises = Exercise.all
    @workout = current_user.workouts.build
    5.times { @workout.custom_exercises.build }
  end

  def create
    @workout = current_user.workouts.build(workout_params)
    if @workout.save
      redirect_to workout_path(@workout)
    else
      @exercises = Exercise.all
      5.times { @workout.custom_exercises.build }
      render :new
    end
  end

  def show
    redirect_to workouts_path if !@workout
    @custom_exercises = @workout.custom_exercises
  end

  private

  def set_workout
    @workout = Workout.find_by(id: params[:id])
  end

  def workout_params
    params.require(:workout).permit(:name, :description, custom_exercises_attributes: [:exercise_id, :rep_range])
  end
end