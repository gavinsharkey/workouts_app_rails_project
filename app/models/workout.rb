class Workout < ApplicationRecord
  belongs_to :user

  has_many :comments, inverse_of: 'workout', dependent: :destroy

  has_many :user_saved_workouts, foreign_key: :saved_workout_id, dependent: :destroy
  has_many :saved_users, through: :user_saved_workouts

  has_many :custom_exercises, dependent: :destroy
  has_many :exercises, through: :custom_exercises

  validates :name, presence: true
  validates :description, presence: true

  accepts_nested_attributes_for :custom_exercises, allow_destroy: true, reject_if: proc { |attrs| attrs['exercise_id'].blank? }

  scope :newest_first, -> { order(created_at: :desc) }
  scope :by_exercise, ->(exercise_name) { joins(:custom_exercises).joins(:exercises).where('exercises.name LIKE ? ', "%#{exercise_name}%").distinct }
  scope :by_user, ->(user_name) { joins(:user).where('users.name LIKE ?', "%#{user_name}%").distinct }

  def comments_by_created_at
    self.comments.includes(:user).order(created_at: :desc)
  end
end
