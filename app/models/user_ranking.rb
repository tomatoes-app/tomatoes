class UserRanking
  include Mongoid::Document

  def user
    User.find(_id)
  end
end
