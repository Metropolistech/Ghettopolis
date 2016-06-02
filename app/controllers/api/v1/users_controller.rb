class Api::V1::UsersController < ApplicationController
  include FilterParamsConcern
  include ImagesConcern

  skip_before_action :authenticate_user_from_token!, only: [:index, :show]
  skip_before_action :verify_user_confirmation!

  before_action :exist_required_params?, only: [:update]
  before_action :find_user_by_username_or_id, only: [:show, :update]
  before_action :filtered_params, only: [:update]

  before_action only: [:update] do
    create_image_to_entity current_user
  end

  before_action only: [:update] do
    update_networks_if_requested @filtered_params["networks"]
  end

  # GET /api/v1/users
  def index
    res_send data: User.all
  end

  # GET /api/v1/users/:id
  def show
    attributes = params[:populate].blank? ? [] : params[:populate].split(",")
    return res_send data: @requested_user.populate(attributes) if @requested_user
    res_send(status: 204)
  end

  # PUT /api/v1/users/:id
  def update
    return res_send status: 204 if @requested_user.blank?
    return res_send status: 401 if @requested_user.id != current_user.id && !current_user.is_admin
    return res_send data: @requested_user if @requested_user.update(@filtered_params)
    res_send data: @requested_user.errors.messages, error: true
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
          :skills,
          :image_data,
          :networks => [:facebook, :twitter, :youtube, :linkedin]
        )
      rescue
        nil
    end

    def exist_required_params?
      return res_send data:[ActionRecord: "Missing required user parameter"], error: true unless required_params
    end

    def find_user_by_username_or_id
      _id = params[:id]
      @requested_user = User.find_by_lower_username(_id).first || User.find_by_id(_id)
    end

    def filtered_params
      @filtered_params = rename_params(key: :skills, to: :skill_list)
    end

    def update_networks_if_requested(networks)
      @filtered_params["networks"] = current_user.networks
        .merge(networks) unless @filtered_params["networks"].blank?
    end
end
