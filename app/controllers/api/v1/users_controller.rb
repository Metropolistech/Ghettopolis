class Api::V1::UsersController < ApplicationController
  # GET /api/v1/users
  def index
    res_send(data: User.all)
  end

  # GET /api/v1/users/:id
  def show
    res_send(data: User.find(params[:id]))
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
