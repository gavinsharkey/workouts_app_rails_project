class ExercisesController < ApplicationController
  def show
    @exercise = Exercise.find_by(id: params[:id])
    if !@exercise
      flash[:alert] = 'Exercise Not Found'
      redirect_to workouts_path
    end
  end
end
