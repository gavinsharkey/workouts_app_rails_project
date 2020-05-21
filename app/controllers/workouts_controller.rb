class WorkoutsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:user_id]
      @user = User.find_by(id: params[:user_id])
      redirect_to workouts_path if !@user
      @workouts = @user.workouts
    else
      @workouts = Workout.all
    end
  end
end