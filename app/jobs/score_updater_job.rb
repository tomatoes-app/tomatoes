class ScoreUpdaterJob
  include SuckerPunch::Job

  def perform(user_id, delta=1)
    add_delta(user_id, delta, DailyScore)
    add_delta(user_id, delta, WeeklyScore)
    add_delta(user_id, delta, MonthlyScore)
    add_delta(user_id, delta, OverallScore)
  end

  def add_delta(user_id, delta, score_klass, expires_at=nil)
    user_score = score_klass.where(uid: user_id).first
    if user_score.nil?
      SuckerPunch.logger.info("creating new #{score_klass.name} for user #{user_id}")
      user_score = score_klass.create!(uid: user_id, score: delta)
      return
    end

    user_score.inc(score: delta)
  end
end
