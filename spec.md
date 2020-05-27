# Specifications for the Rails Assessment

Specs:
- [x] Using Ruby on Rails for the project
- [x] Include at least one has_many relationship (x has_many y; e.g. User has_many Recipes) 
- [x] Include at least one belongs_to relationship (x belongs_to y; e.g. Post belongs_to User)
- - A User *has many* Workouts, and Workouts *belong to* a User  
- [x] Include at least two has_many through relationships (x has_many y through z; e.g. Recipe has_many Items through Ingredients)
- [x] Include at least one many-to-many relationship (x has_many y through z, y has_many x through z; e.g. Recipe has_many Items through Ingredients, Item has_many Recipes through Ingredients)
- - One feature I wanted was the ability to save another user's workout, so I created a  
join table between users and workouts called user_saved_workouts. Through this association, a user  
*has many* saved workouts, and a workout *has_many* saved users.
```
class Workout < ApplicationRecord
  has_many :user_saved_workouts, foreign_key: :saved_workout_id
  has_many :saved_users, through: :user_saved_workouts

class User < ApplicationRecord
  has_many :user_saved_workouts, foreign_key: :saved_user_id
  has_many :saved_workouts, through: :user_saved_workouts

class UserSavedWorkout < ApplicationRecord
  belongs_to :saved_workout, class_name: 'Workout'
  belongs_to :saved_user, class_name: 'User'
```
- [x] The "through" part of the has_many through includes at least one user submittable attribute, that is to say, some attribute other than its foreign keys that can be submitted by the app's user (attribute_name e.g. ingredients.quantity)
- - Another many-to-many relationship in my schema would be the association between workouts and exercises.  
When a user adds an exercise to their workout, they're actually creating an instance of the custom_exercises join table. As well as being a join for workouts and exercises, the table also has columns for rep_range and sets,  
allowing the user to customize an exercise to their needs.
```
class Workout < ApplicationRecord
  has_many :custom_exercises
  has_many :exercises, through: :custom_exercises, dependent: :destroy

class CustomExercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise

class Exercise < ApplicationRecord
  has_many :custom_exercises
  has_many :workouts, through: :custom_exercises, dependent: :destroy

# schema.rb

create_table "custom_exercises", force: :cascade do |t|
  t.integer "workout_id"
  t.integer "exercise_id"
  t.datetime "created_at", precision: 6, null: false
  t.datetime "updated_at", precision: 6, null: false
  t.string "rep_range"
  t.integer "sets"
  t.index ["exercise_id"], name: "index_custom_exercises_on_exercise_id"
  t.index ["workout_id"], name: "index_custom_exercises_on_workout_id"
end
```
- [ ] Include reasonable validations for simple model objects (list of model objects with validations e.g. User, Recipe, Ingredient, Item)
- [ ] Include a class level ActiveRecord scope method (model object & class method name and URL to see the working feature e.g. User.most_recipes URL: /users/most_recipes)
- [ ] Include signup (how e.g. Devise)
- [ ] Include login (how e.g. Devise)
- [ ] Include logout (how e.g. Devise)
- [ ] Include third party signup/login (how e.g. Devise/OmniAuth)
- [ ] Include nested resource show or index (URL e.g. users/2/recipes)
- [ ] Include nested resource "new" form (URL e.g. recipes/1/ingredients/new)
- [ ] Include form display of validation errors (form URL e.g. /recipes/new)

Confirm:
- [ ] The application is pretty DRY
- [ ] Limited logic in controllers
- [ ] Views use helper methods if appropriate
- [ ] Views use partials if appropriate