class ScoreOnLeaderboardJob
  include SuckerPunch::Job

  def perform(user_id)
    today_rank = UserRankingToday.where(_id: user_id).first
    if today_rank && today_rank.created_at.to_date != Time.now.to_date
      SuckerPunch.logger.info("deleting old today ranking for user #{user_id}")
      today_rank.destroy
      today_rank = nil
    end

    if today_rank.nil?
      SuckerPunch.logger.info("creating new today ranking for user #{user_id}")
      today_rank = UserRankingToday.create!(_id: user_id, value: 1)
      return
    end

    today_rank.value += 1
    today_rank.save!
  end
end
