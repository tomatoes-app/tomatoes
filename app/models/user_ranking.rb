class UserRanking
  def self.users_array
    begin
      User.find(all.entries.collect(&:_id))
    rescue Mongoid::Errors::DocumentNotFound
      []
    end
  end

  def self.users_hash
    Hash[*users_array.collect {|u| [u._id, u]}.flatten]
  end

  def self.users
    @@users ||= users_hash
  end

  def user
    @user ||= UserRankingAllTime.users[_id]
  end
end