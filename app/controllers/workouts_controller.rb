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

  def show
    redirect_to workouts_path if !@workout
  end

  private

  def set_workout
    @workout = Workout.find_by(id: params[:id])
  end
end