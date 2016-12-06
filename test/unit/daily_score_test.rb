require 'test_helper'

class DailyScoreTest < ActiveSupport::TestCase
  setup do
    @user = User.create!
  end

  teardown do
    User.destroy_all
    DailyScore.destroy_all
  end

  test 'creates a new daily score' do
    score = DailyScore.create(user: @user, score: 10)
    assert_equal score.s, 10
    assert_equal score.user, @user
    assert_equal @user.daily_score, score
  end

  test 'creates a new daily score with uid' do
    score = DailyScore.create(uid: @user._id, score: 10)
    assert_equal score.s, 10
    assert_equal score.user, @user
    @user.reload
    assert_equal @user.daily_score, score
  end
end
