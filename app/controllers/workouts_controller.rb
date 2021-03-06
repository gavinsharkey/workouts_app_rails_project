class WorkoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout, only: [:show, :edit, :update, :destroy]

  def index
    @workout = Workout.new
    @exercises = Exercise.alphabetical
    @users = User.alphabetical
    if params[:user_id]
      @user = User.find_by(id: params[:user_id])
      if !@user
        redirect_to workouts_path, alert: 'User Not Found' 
      else
        if params[:exercise_name] && params[:exercise_name].present?
          @workouts = @user.workouts.by_exercise(params[:exercise_name])
        else
          @workouts = @user.workouts
        end
      end
    elsif params[:exercise_name].try(:present?) || params[:user_name].try(:present?)
      @workouts = Workout.by_exercise(params[:exercise_name]).by_user(params[:user_name])
    else
      @workouts = Workout.newest_first
    end
  end

  def new
    @exercises = Exercise.alphabetical
    @workout = current_user.workouts.build
    5.times { @workout.custom_exercises.build }
  end

  def create
    @workout = current_user.workouts.build(workout_params)
    if @workout.save
      redirect_to workout_path(@workout)
    else
      @exercises = Exercise.alphabetical
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
      @comment = @workout.comments.build
    end
  end

  def edit
    @exercises = Exercise.alphabetical
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
      @exercises = Exercise.alphabetical
      render :edit
    end
  end

  def destroy
    @workout.destroy
    redirect_to user_path(current_user)
  end

  private

  def set_workout
    @workout = Workout.find_by(id: params[:id])
  end

  def workout_params
    params.require(:workout).permit(:name, :description, custom_exercises_attributes: [:id, :_destroy, :exercise_id, :rep_range, :sets])
  end
end