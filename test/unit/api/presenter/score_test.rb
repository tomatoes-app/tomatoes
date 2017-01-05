require 'test_helper'

module Api
  module Presenter
    class ScoreTest < ActiveSupport::TestCase
      setup do
        @user = ::User.create!
        @user.tomatoes.create!
        @score = DailyScore.find_by(uid: @user._id)

        @orphan_score = DailyScore.create!(score: 123)
      end

      teardown do
        ::Tomato.delete_all
        ::User.destroy_all
      end

      test '#as_json should include score\'s attributes' do
        presenter = Api::Presenter::Score.new(@score)

        assert_equal({
                       user: {
                         id: @user.id.to_s,
                         name: @user.name,
                         image: @user.image_file
                       },
                       score: 1
                     }, presenter.as_json)
      end

      test '#as_json should not fail if there\'s no user associated' do
        presenter = Api::Presenter::Score.new(@orphan_score)

        assert_equal({
                       user: {
                         id: nil,
                         name: nil,
                         image: nil
                       },
                       score: 123
                     }, presenter.as_json)
      end
    end
  end
end
