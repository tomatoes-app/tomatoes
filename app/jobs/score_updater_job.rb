class ScoreUpdaterJob
  include SuckerPunch::Job

  def perform(user_id, score=1)
    add_score(user_id, score, DailyScore)
    add_score(user_id, score, WeeklyScore)
    add_score(user_id, score, MonthlyScore)
    add_score(user_id, score, OverallScore)
  end

  def add_score(user_id, score, score_klass, expires_at=nil)
    user_score = score_klass.where(uid: user_id).first
    if user_score.nil?
      SuckerPunch.logger.info("creating new #{score_klass.name} for user #{user_id}")
      user_score = score_klass.create!(uid: user_id, s: score)
      return
    end

    user_score.s += score
    user_score.save!
  end
end
