class UserRanking
  def user
    @user ||= User.where(_id: _id).first
  end
end
