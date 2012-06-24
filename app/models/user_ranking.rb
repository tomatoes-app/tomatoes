class UserRanking
  def self.users
    @@users ||= Hash[*User.find(all.entries.collect(&:_id)).collect {|u| [u._id, u] }.flatten]
  end

  def user
    @user ||= UserRankingAllTime.users[_id]
  end
end