class Api::V1::UsersController < ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]

  # GET /api/v1/users
  def index
    res_send(data: User.all)
  end

  # GET /api/v1/users/:id
  def show
    @user = User.find_by_id(params[:id])
    @user ? res_send(data: @user) : res_send(status: 204)
  end

  # PUT /api/v1/users/:id
  def update
    if users_params
      @user = User.find_by_id(params[:id])
      return res_send(data: @user) if @user.update(users_params)
    else
      return res_send(data:[updateRecord: "Parameters are missing"], status: 400, error: true)
    end
    res_send(data: @user.errors.messages, status: 400, error: true)
  end

  def destroy

  end

  private

  def users_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :is_admin)
    rescue
      nil
  end

  def to_populate
    !params[:populate].blank?
  end
end
