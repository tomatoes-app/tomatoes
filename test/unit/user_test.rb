require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @auth = {
      'info' => {
        'name'     => 'John Doe',
        'email'    => 'email@example.com',
        'nickname' => 'john',
        'image'    => 'image'
      },
      'credentials' => {
        'token' => 'a token',
        'secret' => 'a secret'
      },
      'extra' => {
        'raw_info' => {
          'gravatar_id' => 'gravatar',
          'avatar_url' => 'avatar_url'
        }
      },
      'provider' => 'provider',
      'uid' => 'uid'
    }
  end

  teardown do
    User.destroy_all
  end

  test 'is valid' do
    user = User.new

    assert user.valid?
  end

  test 'volume, if set, must be a number' do
    user = User.new(volume: 'test')

    assert_not user.valid?
    assert_includes user.errors.messages[:volume], 'is not a number'
  end

  test 'volume, if set, must be a number greater than or equal to zero' do
    user = User.new(volume: -1)

    assert_not user.valid?
    assert_includes user.errors.messages[:volume], 'must be greater than or equal to 0'
  end

  test 'volume, if set, must be a number less than 4' do
    user = User.new(volume: 4)

    assert_not user.valid?
    assert_includes user.errors.messages[:volume], 'must be less than 4'
  end

  test 'color, if set, must have a hexadecimal color format' do
    user = User.new(color: 'test')

    assert_not user.valid?
    assert_includes user.errors.messages[:color], 'is invalid'

    user.color = '#AFfa09'
    assert user.valid?
  end

  test 'work_hours_per_day, if set, must be a number' do
    user = User.new(work_hours_per_day: 'test')

    assert_not user.valid?
    assert_includes user.errors.messages[:work_hours_per_day], 'is not a number'
  end

  test 'work_hours_per_day, if set, must be a number greater than zero' do
    user = User.new(work_hours_per_day: 0)

    assert_not user.valid?
    assert_includes user.errors.messages[:work_hours_per_day], 'must be greater than 0'
  end

  test 'average_hourly_rate, if set, must be a number' do
    user = User.new(average_hourly_rate: 'test')

    assert_not user.valid?
    assert_includes user.errors.messages[:average_hourly_rate], 'is not a number'
  end

  test 'average_hourly_rate, if set, must be a number greater than zero' do
    user = User.new(average_hourly_rate: 0)

    assert_not user.valid?
    assert_includes user.errors.messages[:average_hourly_rate], 'must be greater than 0'
  end

  test 'currency must be one of the supported currencies' do
    user = User.new(currency: 'bitcoin')

    assert_not user.valid?
    assert_includes user.errors.messages[:currency], 'is not included in the list'

    # Choose "randomly" a supported currency value
    user.currency = User::CURRENCIES.keys.sample
    assert user.valid?
  end

  test 'self.find_by_token' do
    user = User.create!
    user.authorizations.create!(token: '123')

    assert_equal User.find_by_token('123'), user
  end

  test 'self.find_by_omniauth' do
    user = User.create_with_omniauth!(@auth)

    assert_equal User.find_by_omniauth(@auth), user
  end

  test 'self.create_with_omniauth!' do
    user = User.create_with_omniauth!(@auth)

    assert_equal user.name, 'John Doe'
    assert_equal user.email, 'email@example.com'
  end

  test 'self.create_with_omniauth! with invalid email' do
    @auth['info']['email'] = 'invalid email'

    assert_nothing_raised { User.create_with_omniauth!(@auth) }
  end

  test "update_omniauth_attributes! doesn't update existing user data" do
    user = User.create_with_omniauth!(@auth)
    user.update_omniauth_attributes!(@auth.merge('info' => { 'name' => 'Johnny Doe' }))

    assert_equal user.name, 'John Doe'
  end

  test 'update_omniauth_attributes! updates missing user data' do
    user = User.create_with_omniauth!(@auth)
    user.name = ''
    user.update_omniauth_attributes!(@auth.merge('info' => { 'name' => 'Johnny Doe' }))

    assert_equal user.name, 'Johnny Doe'
  end

  test 'self.omniauth_attributes should parse auth hash and return user attributes' do
    expected = {
      name:  'John Doe',
      email: 'email@example.com',
      image: 'image'
    }

    assert_equal User.omniauth_attributes(@auth), expected
  end

  test "omniauth_attributes shouldn't return auth data for existing attributes" do
    user = User.create_with_omniauth!(@auth)

    assert_equal user.omniauth_attributes(@auth), image: 'image'
  end

  test 'omniauth_attributes should return auth data for empty user attributes' do
    user = User.create_with_omniauth!(@auth)
    user.email = ''

    assert_equal user.omniauth_attributes(@auth), email: 'email@example.com', image: 'image'
  end

  test "nickname should return first authorization's nickname" do
    user = User.create_with_omniauth!(@auth)

    assert_equal user.nickname, 'john'
  end

  test 'image_file should return user image' do
    user = User.create_with_omniauth!(@auth)

    assert_equal 'image', user.image_file
  end

  test 'image_file should return default image if image attribute is empty' do
    user = User.create_with_omniauth!(@auth.merge('info' => { 'image' => '' }))

    assert_equal User::DEFAULT_IMAGE_FILE, user.image_file
  end

  test 'time_zone should return time_zone only if not blank' do
    user = User.new(time_zone: '')
    assert_nil user.time_zone

    user.time_zone = 'timezone'
    assert user.time_zone, 'timezone'
  end
end
