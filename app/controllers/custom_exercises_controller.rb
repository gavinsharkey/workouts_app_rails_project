class CustomExercisesController < ApplicationController
  def create
    @workout = Workout.find_by(id: params[:workout_id])
    @custom_exercise = @workout.custom_exercises.build(custom_exercise_params)
    if @custom_exercise.save
      redirect_to edit_workout_path(@workout)
    else
      @exercises = Exercise.all
      render :'workouts/edit'
    end
  end

  private

  def custom_exercise_params
    params.require(:custom_exercise).permit(:exercise_id, :rep_range)
  end
end
