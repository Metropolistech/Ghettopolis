class Api::V1::ProjectsController < ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]

  # GET /api/v1/projects
  def index
    puts Project.all
    res_send(data: Project.all)
  end

  # GET /api/v1/projects/:id
  def show
    res_send(data: Project.find(params[:id]))
  end

  # Only admin can access to this route
  def update

  end

  # Only admin can access to this route
  def create

  end

  # Only admin can access to this route
  def destroy

  end
end
