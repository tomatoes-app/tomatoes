class ScoreOnLeaderboardJob
  include SuckerPunch::Job

  def perform(user_id, score=1)
    rank_on_leaderboard(user_id, score, UserRankingToday, 'to_date')
  end

  def rank_on_leaderboard(user_id, score, leaderboard_klass, time_method)
    rank = leaderboard_klass.where(_id: user_id).first
    if rank && rank.created_at.try(time_method) != Time.now.try(time_method)
      SuckerPunch.logger.info("deleting old #{leaderboard_klass.name} ranking for user #{user_id}")
      rank.destroy
      rank = nil
    end

    if rank.nil?
      SuckerPunch.logger.info("creating new #{leaderboard_klass.name} ranking for user #{user_id}")
      rank = leaderboard_klass.create!(_id: user_id, value: score)
      return
    end

    rank.value += score
    rank.save!
  end
end
