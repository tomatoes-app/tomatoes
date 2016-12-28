require 'test_helper'

module Api
  module Presenter
    class ProjectTest < ActiveSupport::TestCase
      setup do
        @user = ::User.create!
        @project = @user.projects.create!(
          name: 'Test project',
          money_budget: 123,
          time_budget: 234)
      end

      teardown do
        ::User.destroy_all
        ::Project.destroy_all
      end

      test '#as_json should include project\'s attributes' do
        presenter = Api::Presenter::Project.new(@project)

        assert_equal({
                       id: @project.id.to_s,
                       created_at: @project.created_at,
                       updated_at: @project.updated_at,
                       tags: [],
                       name: 'Test project',
                       money_budget: 123,
                       time_budget: 234
                     }, presenter.as_json)
      end
    end
  end
end
