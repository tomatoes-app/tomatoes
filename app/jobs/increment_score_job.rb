class IncrementScoreJob
  include SuckerPunch::Job

  def perform(user_id, score=1)
    increment = IncrementScore.new(user_id, score, SuckerPunch.logger)
    increment.process()
  end
end
