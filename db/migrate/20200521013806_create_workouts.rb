class CreateWorkouts < ActiveRecord::Migration[6.0]
  def change
    create_table :workouts do |t|
      t.belongs_to :user
      t.string :name
      t.text :description
      t.timestamps
    end
  end
end
