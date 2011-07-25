module UsersHelper
  def user_avatar(user)
    image_tag "http://gravatar.com/avatar/#{user.gravatar_id}?s=24"
  end
end
