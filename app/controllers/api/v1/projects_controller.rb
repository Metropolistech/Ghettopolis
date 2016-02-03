class Api::V1::ProjectsController < ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]

  # GET /api/v1/projects
  def index
    res_send(data: Project.all)
  end

  # GET /api/v1/projects/:id
  def show
    @project = Project.find_by_id(params[:id])

    attributes = params[:populate].blank? ? [] : params[:populate].split(",")
    return res_send data: @project.populate(attributes) if @project

    res_send(status: 204)
  end

  # PUT /api/v1/projects/:id
  def update
    if projects_params
      @project = current_user.update_project!(data: projects_params, project_id: params[:id])

      if @project
        return res_send data: @project if @project.errors.blank?
        return res_send data: @project.errors.messages, error: true
      end

      return res_send status: 204
    end
    res_send data:[updateRecord: "Missing required project parameter"], error: true
  end

  # POST /api/v1/projects
  def create
    if projects_params
      @project = current_user.create_project!(data: projects_params)
      return res_send data: @project, status: 201 if @project.errors.blank?
      return res_send data: @project.errors.messages, error: true
    end
    res_send data:[createRecord: "Missing required project parameter"], error: true
  end

  # Only admin can access to this route
  def destroy

  end

  # POST /api/v1/projects/:project_id/follow
  def follow
    current_user.follow_project!(params[:project_id]) ? res_send : res_send(status: 204)
  end

  # POST /api/v1/projects/:project_id/unfollow
  def unfollow
    current_user.unfollow_project!(params[:project_id]) ? res_send : res_send(status: 204)
  end

  private

  def projects_params
      params.require(:project).permit(
        :title,
        :youtube_id,
        :room_max,
        :description,
        :status,
        :cover_id
      )
    rescue
      nil
  end
end
