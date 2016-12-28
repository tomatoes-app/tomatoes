require 'test_helper'

class IncrementScoreJobTest < ActiveSupport::TestCase
  setup do
    @user = User.create!
  end

  teardown do
    User.destroy_all
    DailyScore.destroy_all
    WeeklyScore.destroy_all
    MonthlyScore.destroy_all
    OverallScore.destroy_all
  end

  test 'creates a new daily score' do
    assert_equal @user.daily_score, nil
    IncrementScoreJob.new.perform(@user._id)
    @user.reload
    assert_equal @user.daily_score, DailyScore.last
  end

  test 'updates a daily score' do
    score = DailyScore.create(user: @user, score: 10)
    @user.reload
    assert_equal @user.daily_score, score
    IncrementScoreJob.new.perform(@user._id, 2)
    @user.reload
    score.reload
    assert_equal score.score, 12
    assert_equal @user.daily_score, score
    assert_equal DailyScore.count, 1
  end
end
