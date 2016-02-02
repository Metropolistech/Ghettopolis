class Api::V1::UsersController < ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]
  
  # GET /api/v1/users
  def index
    res_send(data: User.all)
  end

  # GET /api/v1/users/:id
  def show
    @user = User.find_by_id(params[:id])
    if @user
      res_send(data: @user.as_json(incude: :projects))
    else
      res_send(status: 204)
    end
  end

  def update

  end

  def create

  end

  def destroy

  end

  private

  def to_populate
    !params[:populate].blank?
  end
end
