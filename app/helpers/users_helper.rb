module UsersHelper
  def current_users_profile?(user)
    user == current_user
  end 
end
