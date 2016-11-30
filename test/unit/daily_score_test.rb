require 'test_helper'

class DailyScoreTest < ActiveSupport::TestCase
  setup do
    @user = User.create!
  end

  teardown do
    User.destroy_all
  end

  test 'creates a new daily score' do
    score = DailyScore.create(user: @user, s: 10)
    assert_equal score.s, 10
    assert_equal score.user, @user
  end
end
