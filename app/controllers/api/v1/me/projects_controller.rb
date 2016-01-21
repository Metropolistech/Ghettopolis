class Api::V1::Me::ProjectsController < Api::BaseController
  def index
    @projects = current_user.projects
  end

  def create

  end

  def update

  end

  def destroy

  end
end
