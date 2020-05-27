class CommentsController < ApplicationController
  def create
    @workout = Workout.find_by(id: params[:workout_id])
    @comment = @workout.comments.build(user: current_user, body: comment_params[:body])
    if @comment.save
      redirect_to workout_path(@workout)
    else
      @custom_exercises = @workout.custom_exercises
      render 'workouts/show'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
