class IncrementScoreJob
  include SuckerPunch::Job

  def perform(user_id, amount=1)
    increment = IncrementScore.new(user_id, amount, SuckerPunch.logger)
    increment.process()
  end
end
