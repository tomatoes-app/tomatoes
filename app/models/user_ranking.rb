class UserRanking
  class << self
    def users_array
      User.find(all.entries.collect(&:_id))
    rescue Mongoid::Errors::DocumentNotFound
      []
    end

    def users_hash
      Hash[*users_array.collect { |u| [u._id, u] }.flatten]
    end

    def users
      @users ||= users_hash
    end
  end

  def user
    @user ||= UserRankingAllTime.users[_id]
  end
end
