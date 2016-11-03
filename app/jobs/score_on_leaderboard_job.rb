class ScoreOnLeaderboardJob
  include SuckerPunch::Job

  def perform(user_id, score=1)
    rank_on_leaderboard(user_id, score, UserRankingToday, '%Y %j')
    rank_on_leaderboard(user_id, score, UserRankingThisWeek, '%Y %W')
    rank_on_leaderboard(user_id, score, UserRankingThisMonth, '%Y %m')
    rank_on_leaderboard(user_id, score, UserRankingAllTime, 'alltime')
  end

  def rank_on_leaderboard(user_id, score, leaderboard_klass, time_format)
    rank = leaderboard_klass.where(_id: user_id).first
    if time_format != 'alltime' && rank && rank.created_at.strftime(time_format) != Time.now.strftime(time_format)
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
