class Api::V1::UsersController < ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]

  # GET /api/v1/users
  def index
    res_send data: User.all
  end

  # GET /api/v1/users/:id
  def show
    @user = User.find_by_id(params[:id])
    if @user
      attributes = params[:populate].blank? ? [] : params[:populate].split(",")
      return res_send(data: @user.populate(attributes))
    end
    res_send(status: 204)
  end

  # PUT /api/v1/users/:id
  def update
    if users_params
      @user = User.find_by_id(params[:id])
      if @user
        return res_send data: @user if @user.update(users_params)
      else
        return res_send status: 204
      end
    else
      return res_send data:[updateRecord: "Parameters are missing"], error: true
    end
    res_send data: @user.errors.messages, error: true
  end

  def destroy

  end

  private

  def populate(attributes)
    to_populate = []
    attributes.split(",").each do |attr|
      if @user.respond_to?(attr)
        to_populate.push(attr)
      end
    end
    @user.as_json(include: to_populate)
  end

  def users_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :is_admin)
    rescue
      nil
  end
end
