module Api
  module Presenter
    class Project
      def initialize(project)
        @project = project
      end

      def as_json(options = {})
        {
          id: @project.id.to_s,
          created_at: @project.created_at,
          updated_at: @project.updated_at,
          tags: @project.tags || [],
          name: @project.name,
          money_budget: @project.money_budget,
          time_budget: @project.time_budget
        }
      end
    end
  end
end
