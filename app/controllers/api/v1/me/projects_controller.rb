class Api::V1::Me::ProjectsController < Api::BaseController
  # GET /me/projects
  def index
    @projects = current_user.projects
  end

  # POST /me/projects
  def create
    if projects_params
      @project = current_user.create_project!(data: projects_params)
      return @project ? @project : render_error(message: "Cannot create project")
    end
    render_error(message: "Missing params")
  end

  # PUT /me/projects/:id
  def update
    if projects_params
      @project = current_user.update_project!(project_id: params[:id], data: projects_params)
      return @project ? @project : render_error(message: "Cannot update project")
    end
    render_error(message: "Missing params")
  end

  def show
    @project = Project.find(params[:id])
  end

  # DELETE /me/projects/:id
  def destroy
    current_user.delete_project!(params[:id])
    render json: { status: 200, data: { message: "Project deleted" } }
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

  private

  def render_error(status: 404, message: "Not found")
    render json: { status: status, errors: { message: message } }, status: status
  end
end
