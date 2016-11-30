require 'test_helper'

class TomatoTest < ActiveSupport::TestCase
  test 'must_not_overlap A' do
    user = User.create!
    user.tomatoes.create!

    assert !user.tomatoes.build.valid?
  end

  test 'must_not_overlap B' do
    user = User.create!
    user.tomatoes.create!(created_at: Time.zone.now - Tomato::DURATION.seconds + 5.seconds)
    assert !user.tomatoes.build.valid?
  end

  test 'must_not_overlap C' do
    user = User.create!
    user.tomatoes.create!(created_at: Time.zone.now - Tomato::DURATION.seconds - 1.second)

    assert user.tomatoes.build.valid?
  end

  test 'must_not_overlap D' do
    user = User.create!
    assert user.tomatoes.build.valid?
  end

  test 'score_on_leaderboard with no previous daily score' do
    user = User.create!
    user.tomatoes.create!
    assert UserRankingToday.where(_id: user._id).count() == 1
    assert UserRankingToday.where(_id: user._id).first.value == 1
  end

  test 'score_on_leaderboard with previous daily score' do
    user = User.create!
    UserRankingToday.create!(_id: user._id, value: 2)
    user.tomatoes.create!
    assert UserRankingToday.where(_id: user._id).count() == 1
    assert UserRankingToday.where(_id: user._id).first.value == 3
  end

  test 'score_on_leaderboard with previous old daily score' do
    user = User.create!
    rank = UserRankingToday.create!(_id: user._id, value: 2)
    rank.created_at = Time.now - 1.days
    rank.save!
    user.tomatoes.create!
    assert UserRankingToday.where(_id: user._id).count() == 1
    assert UserRankingToday.where(_id: user._id).first.value == 1
  end

  test 'score_on_leaderboard with no previous weekly score' do
    user = User.create!
    user.tomatoes.create!
    assert UserRankingThisWeek.where(_id: user._id).count() == 1
    assert UserRankingThisWeek.where(_id: user._id).first.value == 1
  end

  test 'score_on_leaderboard with previous weekly score' do
    user = User.create!
    UserRankingThisWeek.create!(_id: user._id, value: 2)
    user.tomatoes.create!
    assert UserRankingThisWeek.where(_id: user._id).count() == 1
    assert UserRankingThisWeek.where(_id: user._id).first.value == 3
  end

  test 'score_on_leaderboard with previous old weekly score' do
    user = User.create!
    rank = UserRankingThisWeek.create!(_id: user._id, value: 2)
    rank.created_at = Time.now - 8.days
    rank.save!
    user.tomatoes.create!
    assert UserRankingThisWeek.where(_id: user._id).count() == 1
    assert UserRankingThisWeek.where(_id: user._id).first.value == 1
  end

  test 'score_on_leaderboard with no previous monthly score' do
    user = User.create!
    user.tomatoes.create!
    assert UserRankingThisMonth.where(_id: user._id).count() == 1
    assert UserRankingThisMonth.where(_id: user._id).first.value == 1
  end

  test 'score_on_leaderboard with previous monthly score' do
    user = User.create!
    UserRankingThisMonth.create!(_id: user._id, value: 2)
    user.tomatoes.create!
    assert UserRankingThisMonth.where(_id: user._id).count() == 1
    assert UserRankingThisMonth.where(_id: user._id).first.value == 3
  end

  test 'score_on_leaderboard with previous old monthly score' do
    user = User.create!
    rank = UserRankingThisMonth.create!(_id: user._id, value: 2)
    rank.created_at = Time.now - 31.days
    rank.save!
    user.tomatoes.create!
    assert UserRankingThisMonth.where(_id: user._id).count() == 1
    assert UserRankingThisMonth.where(_id: user._id).first.value == 1
  end

  test 'score_on_leaderboard with no previous alltime score' do
    user = User.create!
    user.tomatoes.create!
    assert UserRankingAllTime.where(_id: user._id).count() == 1
    assert UserRankingAllTime.where(_id: user._id).first.value == 1
  end

  test 'score_on_leaderboard with previous alltime score' do
    user = User.create!
    UserRankingAllTime.create!(_id: user._id, value: 2)
    user.tomatoes.create!
    assert UserRankingAllTime.where(_id: user._id).count() == 1
    assert UserRankingAllTime.where(_id: user._id).first.value == 3
  end
end
