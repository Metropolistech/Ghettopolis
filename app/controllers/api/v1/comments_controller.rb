class Api::V1::CommentsController < ApplicationController
  include CommentsConcern

  before_action :check_params, except: :destroy

  def create
    project = Project.find_by_id(params[:project_id])
    return res_send status: 204 unless project

    comment = create_comment user: current_user, data: required_params_exist
    return res_send error: true unless comment

    project.comments[comment[:id]] = comment
    project.save ? res_send(data: project) : res_send(data: project.errors.messages, error: true)
  end

  def update
    project = Project.find_by_id(params[:project_id])
    return res_send status: 204 unless project

    _id = params[:id]
    comment = project.comments[_id]

    return res_send status: 401 if current_user.id != comment[:user][:id]

    updated = update_comment comment: comment, data: required_params_exist
    return res_send error: true unless updated

    project.comments[_id] = updated
    project.save ? res_send(data: project) : res_send(data: project.errors.messages, error: true)
  end

  def destroy

  end

  private

  def required_params_exist
      params.require(:comment).permit(:content)
    rescue
      nil
  end

  def check_params
    res_send error: true unless required_params_exist
  end
end
