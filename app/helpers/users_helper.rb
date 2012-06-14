module UsersHelper
  def profile_image(user, size=24)
    image_tag user.authorizations && !user.authorizations.empty? ? user.authorizations.first.image : '', :width => size
  end
  
  def user_name(user)
    link_to user.name ? user.name : user.login, user
  end
end
