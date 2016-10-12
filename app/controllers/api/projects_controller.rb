module Api
  class ProjectsController < BaseController
    before_action :authenticate_user!
    before_action :find_project, only: [:show, :update, :destroy]

    def index
      @projects = current_user.projects.order_by([[:created_at, :desc], [:_id, :desc]]).page params[:page]

      render json: Presenter::Projects.new(@projects)
    end

    def show
      render json: Presenter::Project.new(@project)
    end

    def create
      @project = current_user.projects.build(resource_params)

      if @project.save
        render status: :created, json: Presenter::Project.new(@project), location: api_project_url(@project)
      else
        render status: :unprocessable_entity, json: @project.errors
      end
    end

    def update
      if @project.update_attributes(resource_params)
        render json: Presenter::Project.new(@project), location: api_project_url(@project)
      else
        render status: :unprocessable_entity, json: @project.errors
      end
    end

    def destroy
      @project.destroy

      head :no_content
    end

    private

    def find_project
      @project = current_user.projects.find(params[:id])
    end

    def resource_params
      params.require(:project).permit(:name, :tag_list, :money_budget, :time_budget)
    end
  end
end
