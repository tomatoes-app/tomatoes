require 'test_helper'

module Api
  module Presenter
    class ProjectsTest < ActiveSupport::TestCase
      setup do
        @user = User.create!
        @project = @user.projects.create!(
          name: 'Test project',
          money_budget: 123,
          time_budget: 234)

        @projects = @user.projects.order_by([[:created_at, :desc]]).page
      end

      teardown do
        User.destroy_all
        ::Project.destroy_all
      end

      test '#as_json should include projects and pagination data' do
        presenter = Api::Presenter::Projects.new(@projects)

        assert_equal 1, presenter.as_json[:projects].size
        assert_equal({
          current_page: 1,
          total_pages: 1,
          total_count: 1
        }, presenter.as_json[:pagination])
      end
    end
  end
end
