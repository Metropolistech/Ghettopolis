class Api::V1::SearchController < ApplicationController
  include SearchTagsConcern
  include SearchUsersConcern
  include SearchProjectsConcern

  skip_before_action :authenticate_user_from_token!
  skip_before_action :verify_user_confirmation!

  def index
    @q = params[:query].downcase

    @tags = search_tags
    @projects = search_projects
    @users = search_users

    res_send data: {
      tags: @tags,
      users: @users,
      projects: @projects
    }
  end
end
