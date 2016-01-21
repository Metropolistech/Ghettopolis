class Api::V1::Me::ProjectsController < Api::BaseController
  def index
    @projects = current_user.projects
  end

  def create
    if projects_params
      @project = current_user.create_project!(data: projects_params)
      return @project ? @project : render_error(message: "Cannot create project")
    end
    render_error(message: "Missing params")
  end

  def update

  end

  def destroy

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
