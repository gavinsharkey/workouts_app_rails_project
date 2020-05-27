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
- [x] Include reasonable validations for simple model objects (list of model objects with validations e.g. User, Recipe, Ingredient, Item)
- - As well as the default validations added by Devise for users, a user must also have a name to be valid.  
```
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: %i[facebook]

  validates :name, presence: true
```
I've also added simple validations for workouts and custom_exercises for name, description, rep_range, and sets
```
class Workout < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true

class CustomExercise < ApplicationRecord
  validates :rep_range, presence: true
  validates :sets, presence: true
```
- [x] Include a class level ActiveRecord scope method (model object & class method name and URL to see the working feature e.g. User.most_recipes URL: /users/most_recipes)
- - For the Workout model, I have a scope method that, given an exercise name, will return a collection of workouts with said exercise.
```
class Workout < ApplicationRecord
  scope :with_exercise, ->(exercise_name) { joins(:custom_exercises).joins(:exercises).where('exercises.name = ?', exercise_name).distinct }
```
On the workouts index page, there's a form that lets you filter the workouts by exercise.
```
<h3>Workouts by exercise: </h3>
<%= form_with(url: workouts_path, method: :get, local: true) do %>
  <%= select_tag :exercise_name, options_from_collection_for_select(@exercises, :name, :name), include_blank: true %>
  <%= submit_tag 'Filter' %>
<% end %>
```
And the submitted *exercise_name* param is used to render the workouts index accordingly.
```
class WorkoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout, only: [:show, :edit, :update, :destroy]

  def index
    @exercises = Exercise.alphabetical
    if params[:user_id]
      @user = User.find_by(id: params[:user_id])
      redirect_to workouts_path if !@user
      @workouts = @user.workouts
    elsif params[:exercise_name] && !params[:exercise_name].blank?
      @workouts = Workout.with_exercise(params[:exercise_name])
    else
      @workouts = Workout.all
    end
  end
```
- [x] Include signup (how e.g. Devise)
- [x] Include login (how e.g. Devise)
- [x] Include logout (how e.g. Devise)
- - I used Devise for user authentication. After adding Devise to my Gemfile, I configured Devise by first running  `rails g devise:install` in console. This generates an initalizer file for configuring Devise settings. After everything is setup properly, I generate the User model by running `rails generate devise User`.  
This command does a lot. Among other things, it creates the users table with an email and encrypted_password column (much like how bcrypt uses a password_digest column), it creates controllers responsible for signup, login, etc. (RegistrationsController, SessionsController, ...), it generates routes and route helpers for things like signup, login, and logout (new_user_registration_path, new_user_session_path, destroy_user_session_path), and much more.

I wanted users to also ahve a name column. so after adding that column to users, I generated my devise views with `rails generate devise:views` and added a name field to the new template for registrations:
```
<h2>Sign up</h2>

<%= form_for(resource, as: resource_name, url: registration_path(resource_name)) do |f| %>
  <%= render "devise/shared/error_messages", resource: resource %>

  <div class="field">
    <%= f.label :name %><br />
    <%= f.text_field :name, autofocus: true, autocomplete: "name" %>
  </div>

  <div class="field">
    <%= f.label :email %><br />
```
- [x] Include third party signup/login (how e.g. Devise/OmniAuth)
- - I decided to use Facebook for third-party authentication.  
Firstly, I added `omniauth`, and `omniauth-facebook` to my Gemfile. I also added `dotenv-rails` so I could store my Facebook key and secret in the environment hash.  
Then, I added provider and uid columns to my users table. This is necessary to later find a user when authentication through Facebook.  
I then added facebook as an omniauth provider in my Devise initializer,
```
Devise.setup do |config|
  config.omniauth :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
```
and made my User model *omniauthable* (which generated the appropriate route helpers for authentication).
```
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: %i[facebook]
```
I added a link to login with Facebook on my login and signup pages.  
```
<%= link_to "Sign in with Facebook", user_facebook_omniauth_authorize_path %>
```
Lastly, I configured an OmniauthCallbacksController,
```
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
```
and added a class method *from_omniauth* to my User model, responsible for either finding or creating a user by the provider and uid:
```
def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.provider = auth.provider
    user.uid = auth.uid
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user.name = auth.info.name
  end
end
```
- [ ] Include nested resource show or index (URL e.g. users/2/recipes)
- [ ] Include nested resource "new" form (URL e.g. recipes/1/ingredients/new)
- [ ] Include form display of validation errors (form URL e.g. /recipes/new)

Confirm:
- [ ] The application is pretty DRY
- [ ] Limited logic in controllers
- [ ] Views use helper methods if appropriate
- [ ] Views use partials if appropriate