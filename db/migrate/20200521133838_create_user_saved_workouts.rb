class CreateUserSavedWorkouts < ActiveRecord::Migration[6.0]
  def change
    create_table :user_saved_workouts do |t|
      t.belongs_to :saved_workout
      t.belongs_to :saved_user
      
      t.timestamps
    end
  end
end
