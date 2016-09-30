module UsersHelper
  def profile_image(user, size = 24)
    image_tag user.image_file, width: size
  end

  def user_name(user)
    link_to user.name || user.nickname, user, class: 'user_name'
  end

  def hex_to_rgba(hex)
    m = hex.match /#(..)(..)(..)/
    "rgba(#{m[1].hex}, #{m[2].hex}, #{m[3].hex}, .7)"
  end
end
