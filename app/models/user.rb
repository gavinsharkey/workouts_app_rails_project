class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: %i[facebook]

  has_many :workouts
  has_many :comments, inverse_of: 'user', dependent: :destroy

  has_many :user_saved_workouts, foreign_key: :saved_user_id, dependent: :destroy
  has_many :saved_workouts, through: :user_saved_workouts

  validates :name, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
    end
  end
end
