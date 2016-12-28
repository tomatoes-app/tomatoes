require 'test_helper'

module Api
  module Presenter
    class TomatoTest < ActiveSupport::TestCase
      setup do
        @user = ::User.create!
        @tomato = @user.tomatoes.build
        @tomato.created_at = 1.hour.ago
        @tomato.save!
        @tomato_with_tags = @user.tomatoes.create!(tag_list: 'one, two')
      end

      teardown do
        ::User.destroy_all
        ::Tomato.delete_all
      end

      test '#as_json should include tomato\'s id, timestamps, and tags' do
        presenter = Api::Presenter::Tomato.new(@tomato)

        assert_equal({
                       id: @tomato.id.to_s,
                       created_at: @tomato.created_at,
                       updated_at: @tomato.updated_at,
                       tags: []
                     }, presenter.as_json)
      end

      test '#as_json should include tomato\'s id, timestamps, and tags (with tags)' do
        presenter = Api::Presenter::Tomato.new(@tomato_with_tags)

        assert_equal({
                       id: @tomato_with_tags.id.to_s,
                       created_at: @tomato_with_tags.created_at,
                       updated_at: @tomato_with_tags.updated_at,
                       tags: %w(one two)
                     }, presenter.as_json)
      end
    end
  end
end
