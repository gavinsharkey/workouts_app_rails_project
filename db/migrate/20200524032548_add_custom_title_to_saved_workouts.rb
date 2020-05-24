class AddCustomTitleToSavedWorkouts < ActiveRecord::Migration[6.0]
  def change
    add_column :user_saved_workouts, :custom_title, :string
  end
end
