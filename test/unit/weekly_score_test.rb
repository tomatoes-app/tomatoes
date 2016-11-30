require 'test_helper'

class WeeklyScoreTest < ActiveSupport::TestCase
  setup do
    @user = User.create!
  end

  teardown do
    User.destroy_all
  end

  test 'creates a new weekly score' do
    score = WeeklyScore.create(user: @user, s: 10)
    assert_equal score.s, 10
    assert_equal score.user, @user
    assert_equal @user.weekly_score, score
  end
end
