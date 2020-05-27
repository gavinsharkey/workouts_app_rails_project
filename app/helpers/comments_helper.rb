module CommentsHelper
  def comment_user_name(comment)
    comment.user.try(:name)
  end
end
