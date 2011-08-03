module UsersHelper
  def user_avatar(user, size=24)
    image_tag "http://gravatar.com/avatar/#{user.gravatar_id}?s=#{size}"
  end
end
