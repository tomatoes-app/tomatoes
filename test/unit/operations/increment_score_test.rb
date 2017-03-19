require 'test_helper'

class IncrementScoreTest < ActiveSupport::TestCase
  setup do
    User.destroy_all
    DailyScore.destroy_all
    WeeklyScore.destroy_all
    MonthlyScore.destroy_all
    OverallScore.destroy_all

    @user = User.create!
    @inc_operation = IncrementScore.new(@user._id, 10)
  end

  test 'creates a new daily score' do
    assert_nil @user.daily_score
    @inc_operation.process
    @user.reload
    assert_equal @user.daily_score, DailyScore.last
    assert_equal @user.daily_score.score, 10
  end

  test 'updates a daily score' do
    score = DailyScore.create(user: @user, score: 2)
    @user.reload
    assert_equal @user.daily_score, score
    @inc_operation.process
    @user.reload
    score.reload
    assert_equal score.score, 12
    assert_equal @user.daily_score, score
    assert_equal DailyScore.count, 1
  end

  test 'sets daily score expiration date '\
      'to the end of the current day in America/New_York '\
      'for a user in America/New_York' do
    @user.update_attributes(time_zone: new_york_tz.name)
    @inc_operation.process
    @user.reload
    assert @user.daily_score.present?
    assert_equal(
      @user.daily_score.expires_at.change(usec: 0),
      new_york_tz.now.end_of_day.in_time_zone('UTC').change(usec: 0)
    )
  end

  test 'sets weekly score expiration date '\
      'to the end of the current week in America/New_York '\
      'for a user in America/New_York' do
    @user.update_attributes(time_zone: new_york_tz.name)
    @inc_operation.process
    @user.reload
    assert @user.weekly_score.present?
    assert_equal(
      @user.weekly_score.expires_at.change(usec: 0),
      new_york_tz.now.end_of_week.in_time_zone('UTC').change(usec: 0)
    )
  end

  test 'sets monthly score expiration date '\
      'to the end of the current month in America/New_York '\
      'for a user in America/New_York' do
    @user.update_attributes(time_zone: new_york_tz.name)
    @inc_operation.process
    @user.reload
    assert @user.monthly_score.present?
    assert_equal(
      @user.monthly_score.expires_at.change(usec: 0),
      new_york_tz.now.end_of_month.in_time_zone('UTC').change(usec: 0)
    )
  end

  private

  def new_york_tz
    ActiveSupport::TimeZone['America/New_York']
  end
end
