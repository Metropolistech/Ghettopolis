class Api::V1::UsersController < ApplicationController
  include FilterParamsConcern

  skip_before_filter :authenticate_user_from_token!, only: [:index, :show]
  skip_before_filter :verify_user_confirmation!

  before_filter :exist_required_params?, only: [:update]
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
    return res_send data: @user if @user.update(filtered_params)
    res_send data: @user.errors.messages, error: true
  end

  def destroy

  end

  private
    def required_params
        params.require(:user).permit(
          :username,
          :firstname,
          :lastname,
          :email,
          :password,
          :password_confirmation,
          :is_admin,
          :bio,
          :skills
        )
      rescue
        nil
    end

    def exist_required_params?
      return res_send data:[ActionRecord: "Missing required user parameter"], error: true unless required_params
    end

    def find_user_by_usernae_or_id
      _id = params[:id]
      @user = User.find_by_lower_username(_id).first || User.find_by_id(_id)
    end

    def filtered_params
      filter_params(key: :skills, to: :skill_list)
    end
end
