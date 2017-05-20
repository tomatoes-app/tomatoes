require 'test_helper'

class TomatoTest < ActiveSupport::TestCase
  test 'must_not_overlap A' do
    user = User.create!
    user.tomatoes.create!

    assert !user.tomatoes.build.valid?
  end

  test 'must_not_overlap B' do
    user = User.create!
    user.tomatoes.create!(created_at: Time.zone.now - Tomato::DURATION_MIN.minutes + 5.seconds)
    assert !user.tomatoes.build.valid?
  end

  test 'must_not_overlap C' do
    user = User.create!
    user.tomatoes.create!(created_at: Time.zone.now - Tomato::DURATION_MIN.minutes - 1.second)

    assert user.tomatoes.build.valid?
  end

  test 'must_not_overlap D' do
    user = User.create!
    assert user.tomatoes.build.valid?
  end

  #
  # Daily score
  #

  test 'increment_score with no previous daily score' do
    user = User.create!
    user.tomatoes.create!
    user.reload
    assert user.daily_score
    assert_equal user.daily_score.score, 1
  end

  test 'increment_score with previous daily score' do
    user = User.create!
    DailyScore.create!(uid: user._id, score: 2)
    user.tomatoes.create!
    user.reload
    assert user.daily_score
    assert_equal user.daily_score.score, 3
  end

  test 'decrement_score with previous daily score' do
    user = User.create!
    DailyScore.create!(uid: user._id, score: 2)
    tomato = user.tomatoes.create!
    tomato.destroy
    user.reload
    assert user.daily_score
    assert_equal user.daily_score.score, 2
  end

  #
  # Weekly score
  #

  test 'increment_score with no previous weekly score' do
    user = User.create!
    user.tomatoes.create!
    user.reload
    assert user.weekly_score
    assert_equal user.weekly_score.score, 1
  end

  test 'increment_score with previous weekly score' do
    user = User.create!
    WeeklyScore.create!(uid: user._id, score: 2)
    user.tomatoes.create!
    user.reload
    assert user.weekly_score
    assert_equal user.weekly_score.score, 3
  end

  test 'decrement_score with previous weekly score' do
    user = User.create!
    WeeklyScore.create!(uid: user._id, score: 2)
    tomato = user.tomatoes.create!
    tomato.destroy
    user.reload
    assert user.weekly_score
    assert_equal user.weekly_score.score, 2
  end

  #
  # Monthly score
  #

  test 'increment_score with no previous monthly score' do
    user = User.create!
    user.tomatoes.create!
    user.reload
    assert user.monthly_score
    assert_equal user.monthly_score.score, 1
  end

  test 'increment_score with previous monthly score' do
    user = User.create!
    MonthlyScore.create!(uid: user._id, score: 2)
    user.tomatoes.create!
    user.reload
    assert user.monthly_score
    assert_equal user.monthly_score.score, 3
  end

  test 'decrement_score with previous monthly score' do
    user = User.create!
    MonthlyScore.create!(uid: user._id, score: 2)
    tomato = user.tomatoes.create!
    tomato.destroy
    user.reload
    assert user.monthly_score
    assert_equal user.monthly_score.score, 2
  end

  #
  # Overall score
  #

  test 'increment_score with no previous overall score' do
    user = User.create!
    user.tomatoes.create!
    user.reload
    assert user.overall_score
    assert_equal user.overall_score.score, 1
  end

  test 'increment_score with previous overall score' do
    user = User.create!
    OverallScore.create!(uid: user._id, score: 2)
    user.tomatoes.create!
    user.reload
    assert user.overall_score
    assert_equal user.overall_score.score, 3
  end

  test 'decrement_score with previous overall score' do
    user = User.create!
    OverallScore.create!(uid: user._id, score: 2)
    tomato = user.tomatoes.create!
    tomato.destroy
    user.reload
    assert user.overall_score
    assert_equal user.overall_score.score, 2
  end
end
