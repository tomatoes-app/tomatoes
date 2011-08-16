module UsersHelper
  def avatar(user, size=24)
    image_tag "http://gravatar.com/avatar/#{user.gravatar_id}?s=#{size}"
  end
  
  def name(user)
    link_to user.name.empty? ? user.login : user.name, user
  end
end
