class WorkoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout, only: [:show, :edit, :update, :destroy]

  def index
    @exercises = Exercise.all
    if params[:user_id]
      @user = User.find_by(id: params[:user_id])
      redirect_to workouts_path if !@user
      @workouts = @user.workouts
    elsif params[:exercise_name] && !params[:exercise_name].blank?
      @workouts = Workout.with_exercise(params[:exercise_name])
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
      # 5.times { @workout.custom_exercises.build }
      render :new
    end
  end

  def show
    if !@workout
      flash[:alert] = 'Workout Not Found'
      redirect_to workouts_path
    else
      @custom_exercises = @workout.custom_exercises
    end
  end

  def edit
    @exercises = Exercise.all
    if !@workout
      flash[:alert] = 'Workout Not Found'
      redirect_to workouts_path
    else
      @custom_exercise = CustomExercise.new
    end
  end

  def update
    if @workout.update(workout_params)
      redirect_to workout_path(@workout)
    else
      @exercises = Exercise.all
      render :edit
    end
  end

  def destroy
    @workout.destroy
    redirect_to workouts_path
  end

  private

  def set_workout
    @workout = Workout.find_by(id: params[:id])
  end

  def workout_params
    params.require(:workout).permit(:name, :description, custom_exercises_attributes: [:id, :_destroy, :exercise_id, :rep_range, :sets])
  end
end