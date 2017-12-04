module Api
  class ProjectsController < BaseController
    include ProjectsParams

    before_action :authenticate_user!
    before_action :find_project, only: %i[show update destroy]

    # GET /api/projects
    def index
      @projects = current_user.projects
      @projects = @projects.tagged_with(params[:tag_list].split(',').map(&:strip)) if params[:tag_list]
      @projects = @projects.order_by([%i[created_at desc], %i[_id desc]]).page params[:page]

      render json: Presenter::Projects.new(@projects)
    end

    # GET /api/projects/1
    def show
      render json: Presenter::Project.new(@project)
    end

    # POST /api/projects
    def create
      @project = current_user.projects.build(resource_params)

      if @project.save
        render status: :created, json: Presenter::Project.new(@project), location: api_project_url(@project)
      else
        render status: :unprocessable_entity, json: @project.errors
      end
    end

    # POST /api/projects
    def update
      if @project.update_attributes(resource_params)
        render json: Presenter::Project.new(@project), location: api_project_url(@project)
      else
        render status: :unprocessable_entity, json: @project.errors
      end
    end

    # DELETE /api/projects/1
    def destroy
      @project.destroy

      head :no_content
    end

    private

    def find_project
      @project = current_user.projects.find(params[:id])
    end
  end
end
