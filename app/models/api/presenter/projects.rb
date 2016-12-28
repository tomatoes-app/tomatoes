module Api
  module Presenter
    class Projects
      def initialize(projects)
        @projects = projects
      end

      def as_json(_options = {})
        {
          projects: @projects.map(&Api::Presenter::Project.method(:new)),
          pagination: {
            current_page: @projects.current_page,
            total_pages: @projects.total_pages,
            total_count: @projects.total_count
          }
        }
      end
    end
  end
end
