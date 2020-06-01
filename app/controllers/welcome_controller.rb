class WelcomeController < ApplicationController
  def home
    redirect_to workouts_path if user_signed_in?
  end 
end
