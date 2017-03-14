class ProjectsController < ApplicationController
  include ProjectsParams

  before_action :authenticate_user!
  before_action :find_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  def index
    @projects = current_user.projects.order_by([[:created_at, :desc]]).page params[:page]
  end

  # GET /projects/1
  def show; end

  # GET /projects/new
  def new
    @project = current_user.projects.build
  end

  # GET /projects/1/edit
  def edit; end

  # POST /projects
  def create
    @project = current_user.projects.build(resource_params)

    if @project.save
      redirect_to @project, notice: I18n.t('project.created')
    else
      render action: 'new'
    end
  end

  # PUT /projects/1
  def update
    if @project.update_attributes(resource_params)
      redirect_to @project, notice: I18n.t('project.updated')
    else
      render action: 'edit'
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy

    redirect_to projects_url
  end

  protected

  def find_project
    @project = current_user.projects.find(params[:id])
  end
end
