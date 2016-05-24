class Api::V1::CommentsController < ApplicationController
  include CommentsConcern

  before_action :check_params, except: :destroy
  before_action :check_if_project_exist?
  before_action :is_comment_exist?, only: [:update, :destroy]
  before_action :is_current_user_authorized?, only: [:update, :destroy]

  # POST /api/v1/projects/:project_id/comments
  def create
    comment = create_comment user: current_user, data: required_params_exist
    return res_send error: true unless comment
    @current_project.comments[comment[:id]] = comment
    @current_project.save ? res_send(data: @current_project) : res_send(data: @current_project.errors.messages, error: true)
  end

  # PUT /api/v1/projects/:project_id/comments/:id
  def update
    updated = update_comment comment: @current_comment, data: required_params_exist
    return res_send error: true unless updated

    @current_project.comments[@id] = updated
    @current_project.save ? res_send(data: @current_project) : res_send(data: @current_project.errors.messages, error: true)
  end

  # DELETE /api/v1/projects/:project_id/comments/:id
  def destroy
    @current_project.comments[@id] = destroy_comment comment: @current_comment
    @current_project.save ? res_send(data: @current_project) : res_send(data: @current_project.errors.messages, error: true)
  end

  private
    def check_if_project_exist?
      @current_project = Project.find_by_id(params[:project_id])
      return res_send status: 204 unless @current_project
    end

    def required_params_exist
        params.require(:comment).permit(:content)
      rescue
        nil
    end

    def check_params
      res_send error: true unless required_params_exist
    end

    def is_comment_exist?
      @id = params[:id]
      @current_comment = @current_project.comments[@id]
      return res_send status: 204 if @current_comment.blank?
    end

    def is_current_user_authorized?
      return res_send status: 401 if current_user.id != @current_comment[:user][:id] && !current_user.is_admin?
    end
end
