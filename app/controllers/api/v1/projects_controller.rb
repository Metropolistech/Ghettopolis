class Api::V1::ProjectsController < ApplicationController
  skip_before_filter :authenticate_user_from_token!, only: [:index, :show, :ladder]
  skip_before_filter :verify_user_confirmation!

  before_filter :find_project_by_slug_or_id, only: [:show]
  before_filter :get_populate_attributes, only: [:show]
  before_filter :required_params, only: [:create, :update]

  # GET /api/v1/projects
  def index
    res_send(data: Project.all)
  end

  # GET /api/v1/projects/:id
  def show
    return res_send data: @project.populate(@attributes) if @project
    res_send(status: 204)
  end

  # PUT /api/v1/projects/:id
  def update
    @project = current_user
      .update_project! data: filtered_params, project_id: params[:id]
    return res_send status: 204 unless @project
    return res_send data: @project if @project.errors.blank?
    res_send data: @project.errors.messages, error: true
  end

  # POST /api/v1/projects
  def create
    @project = current_user.create_project!(data: filtered_params)
    return res_send data: @project, status: 201 if @project.errors.blank?
    res_send data: @project.errors.messages, error: true
  end


  # Only admin can access to this route
  def destroy

  end

  # POST /api/v1/projects/:project_id/follow
  def follow
    _id = params[:project_id]
    current_user.follow_project!(_id)
    res_send data: Project.find_by_id(_id).populate(['followers'])
  end

  # POST /api/v1/projects/:project_id/unfollow
  def unfollow
    _id = params[:project_id]
    current_user.unfollow_project!(_id)
    res_send data: Project.find_by_id(_id).populate(['followers'])
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

  def projects_params
      params.require(:project).permit(
        :title,
        :youtube_id,
        :room_max,
        :description,
        :status,
        :cover_id,
        :tags,
        :released_youtube_id
      )
    rescue
      nil
  end

  def ladder_serialize_options
    { except: [:comments], include: { followers: { only: [:id, :username, :avatar] } } }
  end

  def find_project_by_slug_or_id
    @project = Project.find_by_slug(params[:id]) || Project.find_by_id(params[:id])
  end

  def get_populate_attributes
    @attributes = params[:populate].blank? ? [] : params[:populate].split(",")
  end

  def required_params
    return res_send data:[ActionRecord: "Missing required project parameter"], error: true unless projects_params
  end

  def filtered_params
    projects_params
      .to_h
      .rename_key(:tags, :tag_list)
  end
end
