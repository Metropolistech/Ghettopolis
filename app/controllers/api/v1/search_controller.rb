class Api::V1::SearchController < ApplicationController
  skip_before_action :authenticate_user_from_token!
  skip_before_action :verify_user_confirmation!

  def index
    @q = params[:query]

    res_send data: {
      tags: search_tags,
      users: search_users,
      projects: search_projects
    }
  end

  private
    def search_tags
      ActsAsTaggableOn::Tag
        .where("LOWER(name) LIKE :query", query: "%#{@q.downcase}%")
    end

    def search_users
      User.search(@q)
    end

    def search_projects
      Project.search(@q)
    end
end