class ExercisesController < ApplicationController
  before_action :authenticate_user!

  def show
    @exercise = Exercise.find_by(id: params[:id])
    if !@exercise
      flash[:alert] = 'Exercise Not Found'
      redirect_to workouts_path
    end
  end
end
