class Api::V1::UsersController < ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]

  # GET /api/v1/users
  def index
    res_send data: User.all
  end

  # GET /api/v1/users/:id
  def show
    @user = User.find_by_id(params[:id])

    attributes = params[:populate].blank? ? [] : params[:populate].split(",")
    return res_send data: @user.populate(attributes) if @user

    res_send(status: 204)
  end

  # PUT /api/v1/users/:id
  def update
    if users_params
      @user = User.find_by_id(params[:id])

      return res_send status: 204 if @user.blank?
      return res_send status: 401  if @user.id != current_user.id

      if @user.update(users_params)
        return res_send data: @user
      else
        return res_send data: @user.errors.messages, error: true
      end
    end
    res_send data:[updateRecord: "Missing required user parameter"], error: true
  end

  def destroy

  end

  private

  def users_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :is_admin)
    rescue
      nil
  end
end
