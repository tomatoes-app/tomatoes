module UsersHelper
  def avatar(user, size=24)
    image_tag "http://gravatar.com/avatar/#{user.gravatar_id}?s=#{size}"
  end
  
  def user_name(user)
    link_to user.name ? user.name : user.login, user
  end
end
