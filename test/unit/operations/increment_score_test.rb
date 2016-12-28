require 'test_helper'

class IncrementScoreTest < ActiveSupport::TestCase
  setup do
    @user = User.create!
    @inc_operation = IncrementScore.new(@user._id, 10)
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
end
