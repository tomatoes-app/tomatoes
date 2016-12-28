class IncrementScore
  attr_accessor :user_id, :amount, :logger

  def initialize(user_id, amount, logger=Rails.logger)
    self.user_id = user_id
    self.amount = amount
    self.logger = logger
  end

  def process
    now = Time.current
    upsert_score(DailyScore, to_user_timezone(now.end_of_day))
    upsert_score(WeeklyScore, to_user_timezone(now.end_of_week))
    upsert_score(MonthlyScore, to_user_timezone(now.end_of_month))
    upsert_score(OverallScore)
  end

  private

  def upsert_score(score_klass, expires_at=nil)
    user_score = score_klass.where(uid: user_id).first
    if user_score.nil?
      logger.info("creating new #{score_klass.name} for user #{user_id}")
      user_score = score_klass.new(uid: user_id, score: amount)
      user_score.expires_at = expires_at if expires_at
      return user_score.save!
    end

    user_score.inc(score: amount)
  rescue Mongo::Error::OperationFailure => err
    logger.error("Error while creating new score: #{err}")
    retry
  end

  def user
    @user ||= User.find(user_id)
  end

  def to_user_timezone(t)
    t.in_time_zone(user.time_zone)
  end
end
