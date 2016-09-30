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
end
