# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Workout.destroy_all
Exercise.destroy_all

require 'open-uri'
page = Nokogiri::HTML(open('https://guardyourhealth.tumblr.com/post/157357020660/a-to-z-workout'))
page.css('div.article-content ul li')[0..25].each do |exercise_data|
  text = exercise_data.text
  name = text.split(':')[0]
  description = text.split(':')[1].strip
  Exercise.create(name: name, description: description)
end

workouts = ['Chest Day', 'Leg Day', 'Arm', 'Arm Day', 'Hella Pump', 'SICK WORKOUT', 'Glute Destroyer']

5.times do
  u = User.create(name: Faker::Name.first_name, email: Faker::Internet.email, password: 'password')
  3.times do
    w = u.workouts.create(name: workouts.sample, description: Faker::Lorem.sentence)
    5.times do
      e = Exercise.order(Arel.sql('RANDOM()')).first
      w.custom_exercises.create(exercise: e, rep_range: rand(1..12))
    end
  end
end