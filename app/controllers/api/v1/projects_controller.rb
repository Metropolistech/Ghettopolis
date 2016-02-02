class Api::V1::ProjectsController < ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]

  # GET /api/v1/projects
  def index
    res_send(data: Project.all)
  end

  # GET /api/v1/projects/:id
  def show
    @project = Project.find_by_id(params[:id])
    @project ? res_send(data: @project) : res_send(status: 204)
  end

  # PUT /api/v1/projects/:id
  def update
    if projects_params
      @project = Project.find_by_id(params[:id])
      if @project
        return res_send(data: @project) if @project.update(projects_params)
      else
        return res_send(data:[updateRecord: "Cannot update. Ressource does not exist."], status: 400, error: true)
      end
    end
    res_send(data:[updateRecord: "Parameters are missing or malformed."], status: 400, error: true)
  end

  # POST /api/v1/projects
  def create
    if projects_params
      @project = current_user.create_project!(data: projects_params)
      return res_send(data: @project) if @project
    end

    res_send(data:[createRecord: "Parameters are missing or malformed"], status: 400, error: true)
  end

  private

  def projects_params
      params.require(:project).permit(
        :title,
        :youtube_id,
        :room_max,
        :in_competition,
        :is_released,
        :cover_id
      )
    rescue
      nil
  end

  # Only admin can access to this route
  def destroy

  end
end
