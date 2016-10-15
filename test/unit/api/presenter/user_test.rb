require 'test_helper'

module Api
  module Presenter
    class UserTest < ActiveSupport::TestCase
      setup do
        @user = ::User.create!(
          name: 'Giovanni',
          email: 'giovanni@yeah-right.com'
        )

        @user.authorizations.create!(
          provider: 'tomatoes'
        )

        @user.authorizations.create!(
          provider: 'github',
          uid: '123',
          nickname: 'potomak',
          image: 'photo.png'
        )

        t1 = @user.tomatoes.build
        t1.created_at = 1.month.ago
        t1.save!

        t2 = @user.tomatoes.build
        t2.created_at = 1.week.ago
        t2.save!

        @user.tomatoes.create!
      end

      teardown do
        ::User.destroy_all
        ::Tomato.destroy_all
      end

      test '#as_json should include user\'s basic attributes' do
        presenter = Api::Presenter::User.new(@user)

        assert_equal({
          id: @user.id.to_s,
          name: 'Giovanni',
          email: 'giovanni@yeah-right.com',
          created_at: @user.created_at,
          updated_at: @user.updated_at
        }, presenter.as_json.select { |k, _| [:id, :name, :email, :created_at, :updated_at].include?(k) })
      end

      test '#as_json should include only basic auth data' do
        presenter = Api::Presenter::User.new(@user)

        assert_equal([{
          provider: 'github',
          uid: '123',
          nickname: 'potomak',
          image: 'photo.png'
        }], presenter.as_json[:authorizations])
      end

      test '#as_json should include tomatoes counters' do
        presenter = Api::Presenter::User.new(@user)

        assert_equal({
          month: 2,
          week: 1,
          day: 1
        }, presenter.as_json[:tomatoes_counters])
      end
    end
  end
end
