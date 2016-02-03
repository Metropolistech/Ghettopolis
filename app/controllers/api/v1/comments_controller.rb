class Api::V1::CommentsController < ApplicationController
  include CommentsConcern

  def create
    return res_send error: true unless required_params_exist

    project = Project.find_by_id(params[:project_id])
    return res_send status: 204 unless project

    comment = create_comment user: current_user, data: required_params_exist
    return res_send error: true unless comment

    project.comments[comment[:id]] = comment
    project.save ? res_send(data: project) : res_send(data: project.errors.messages, error: true)
  end

  def update

  end

  def destroy

  end

  private

  def required_params_exist
      params.require(:comment).permit(:content)
    rescue
      nil
  end
end
