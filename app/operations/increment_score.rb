class IncrementScore
  attr_accessor :user_id, :amount, :logger

  def initialize(user_id, amount, logger = Rails.logger)
    self.user_id = user_id
    self.amount = amount
    self.logger = logger
  end

  def process
    upsert_score(DailyScore, user_time_zone.now.end_of_day)
    upsert_score(WeeklyScore, user_time_zone.now.end_of_week)
    upsert_score(MonthlyScore, user_time_zone.now.end_of_month)
    upsert_score(OverallScore)
  end

  private

  def upsert_score(score_klass, expires_at = nil)
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

  def user_time_zone
    ActiveSupport::TimeZone[user.time_zone.to_s] || Time.zone
  end
end
