require 'test_helper'

module Api
  module Presenter
    class TomatoesTest < ActiveSupport::TestCase
      setup do
        @user = ::User.create!
        tomato = @user.tomatoes.build
        tomato.created_at = 1.hour.ago
        tomato.save!
        @user.tomatoes.create!(tag_list: 'one, two')

        @tomatoes = @user.tomatoes.order_by([[:created_at, :desc]]).page
      end

      teardown do
        ::User.destroy_all
        ::Tomato.delete_all
      end

      test '#as_json should include tomatoes and pagination data' do
        presenter = Api::Presenter::Tomatoes.new(@tomatoes)

        assert_equal 2, presenter.as_json[:tomatoes].size
        assert_equal({
                       current_page: 1,
                       total_pages: 1,
                       total_count: 2
                     }, presenter.as_json[:pagination])
      end
    end
  end
end
