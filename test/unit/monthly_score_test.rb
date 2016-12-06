require 'test_helper'

class MonthlyScoreTest < ActiveSupport::TestCase
  setup do
    @user = User.create!
  end

  teardown do
    User.destroy_all
    MonthlyScore.destroy_all
  end

  test 'creates a new monthly score' do
    score = MonthlyScore.create(user: @user, score: 10)
    assert_equal score.s, 10
    assert_equal score.user, @user
    assert_equal @user.monthly_score, score
  end
end
