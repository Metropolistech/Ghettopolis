class Api::V1::ProjectsController < ApplicationController
  include FilterParamsConcern
  include ImagesConcern

  skip_before_action :authenticate_user_from_token!, only: [:index, :show, :ladder, :followers]
  skip_before_action :verify_user_confirmation!

  before_action :find_project_by_slug_or_id, only: [:show, :update, :followers, :destroy]
  before_action :get_populate_attributes, only: [:show]
  before_action :exist_required_params?, only: [:create, :update]
  before_action :filtered_params, only: [:create, :update]

  before_action only: [:update] do
    create_image_to_entity @current_project
  end

  # GET /api/v1/projects
  def index
    res_send(data: Project.available)
  end

  # GET /api/v1/projects/:id
  def show
    return res_send status: 204 unless @current_project.deleted_at.blank?
    return res_send data: @current_project.populate(@attributes) if @current_project
    res_send(status: 204)
  end

  # POST /api/v1/projects
  def create
    @current_project = current_user
      .create_project!(data: @filtered_params)
    create_image_to_entity @current_project
    return res_send data: @current_project, status: 201 if @current_project.errors.blank?
    res_send data: @current_project.errors.messages, error: true
  end

  # PUT /api/v1/projects/:id
  def update
    @updated_project = current_user
      .update_project! data: @filtered_params, project_id: @current_project.id
    return res_send status: 204 unless @updated_project
    return res_send data: @updated_project if @updated_project.errors.blank?
    res_send data: @updated_project.errors.messages, error: true
  end

  # DELETE /api/v1/projects/:id
  def destroy
    return res_send status: 401 if current_user.id != @current_project.author.id && !current_user.is_admin?
    @current_project.update_attribute(:deleted_at, Time.now)
    res_send status: 204
  end

  # GET /api/v1/projects/released
  def released
    res_send data: Project.released
  end

  # POST /api/v1/projects/:project_id/follow
  def follow
    _id = params[:project_id]
    project = Project.available.find_by_id(_id)
    return res_send status: 204 if project.blank?
    current_user.follow_project!(_id)
    res_send data: project.populate(['followers'])
  end

  # POST /api/v1/projects/:project_id/unfollow
  def unfollow
    _id = params[:project_id]
    project = Project.available.find_by_id(_id)
    return res_send status: 204 if project.blank?
    current_user.unfollow_project!(_id)
    res_send data: Project.find_by_id(_id).populate(['followers'])
  end

  # GET /api/v1/projects/:project_id/followers
  def followers
    res_send data: @current_project
      .followers.as_json(only: [:id, :username, :avatar], except: [:skills])
  end

  # GET /api/v1/projects/ladder
  def ladder
    res_send data: {
      date: LadderRound.current_round.date,
      projects: Project
      .populate_ladder
      .as_json(ladder_serialize_options)
    }
  end

  private
    def required_params
        params.require(:project).permit(
          :title,
          :youtube_id,
          :room_max,
          :description,
          :status,
          :cover_id,
          :tags,
          :released_youtube_id,
          :image_data
        )
      rescue
        nil
    end

    def filtered_params
      @filtered_params = rename_params(key: :tags, to: :tag_list)
    end

    def ladder_serialize_options
      { except: [:comments], include: { followers: { only: [:id, :username, :avatar] } } }
    end

    def find_project_by_slug_or_id
      _id = params[:id] || params[:project_id]
      @current_project = Project.find_by_slug(_id) || Project.find_by_id(_id)
      res_send status: 204 if @current_project.blank?
    end

    def get_populate_attributes
      @attributes = params[:populate].blank? ? [] : params[:populate].split(",")
    end

    def exist_required_params?
      return res_send data:[ActionRecord: "Missing required project parameter"], error: true unless required_params
    end
end
