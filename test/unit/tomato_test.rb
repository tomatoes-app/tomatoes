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

  test 'score_on_leaderboard with no previous score' do
    user = User.create!
    user.tomatoes.create!
    assert UserRankingToday.where(_id: user._id).count() == 1
    assert UserRankingToday.where(_id: user._id).first.value == 1
  end

  test 'score_on_leaderboard with previous score' do
    user = User.create!
    UserRankingToday.create!(_id: user._id, value: 2)
    user.tomatoes.create!
    assert UserRankingToday.where(_id: user._id).count() == 1
    assert UserRankingToday.where(_id: user._id).first.value == 3
  end

  test 'score_on_leaderboard with previous old score' do
    user = User.create!
    rank = UserRankingToday.create!(_id: user._id, value: 2)
    rank.created_at = Time.now - 1.days
    rank.save!
    user.tomatoes.create!
    assert UserRankingToday.where(_id: user._id).count() == 1
    assert UserRankingToday.where(_id: user._id).first.value == 1
  end
end
