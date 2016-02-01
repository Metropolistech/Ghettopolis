class Api::V1::ProjectsController < ApplicationController
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
