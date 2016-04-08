class Api::V1::UsersController < ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]
  skip_before_filter :verify_user_confirmation!

  before_filter :required_params, only: [:update]
  before_filter :find_user_by_usernae_or_id, only: [:show, :update]

  # GET /api/v1/users
  def index
    res_send data: User.all
  end

  # GET /api/v1/users/:id
  def show
    attributes = params[:populate].blank? ? [] : params[:populate].split(",")
    return res_send data: @user.populate(attributes) if @user
    res_send(status: 204)
  end

  # PUT /api/v1/users/:id
  def update
    return res_send status: 204 if @user.blank?
    return res_send status: 401 if @user.id != current_user.id
    return res_send data: @user if @user.update(users_params)
    res_send data: @user.errors.messages, error: true
  end

  def destroy

  end

  private

  def users_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :is_admin)
    rescue
      nil
  end

  def required_params
    return res_send data:[ActionRecord: "Missing required user parameter"], error: true unless users_params
  end

  def find_user_by_usernae_or_id

    @user = User.where("lower(username) = ?", params[:id].downcase).first || User.find_by_id(params[:id])
  end
end
