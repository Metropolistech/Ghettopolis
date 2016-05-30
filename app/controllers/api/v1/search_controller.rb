class Api::V1::SearchController < ApplicationController
  skip_before_action :authenticate_user_from_token!
  skip_before_action :verify_user_confirmation!

  def index
    @q = params[:query].downcase

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
        .map { |tag|
          { tag: tag, search_score: tag.name.sub(@q) {}.length * 100 * 0.3 }
        }
        .sort_by { |t| t[:search_score] }
        .inject([]) { |obj, tag|
          obj.push(tag[:tag])
          obj
        }
    end

    def search_users
      User
        .search(@q)
        .map { |user|
          { user: user, search_score: user.username.sub(@q) {}.length * 100 * 0.3 }
        }
        .sort_by { |t| t[:search_score] }
        .inject([]) { |obj, tag|
          obj.push(tag[:user])
          obj
        }
    end

    def search_projects
      Project.search(@q).map { |project|
        project
          .search_score = (project.title.downcase.include?(@q) ? 1 : 0 ) * 100 +
          (project.description.downcase.include?(@q) ? 1 : 0) * 80 +
          project.followers.count * 70 +
          project.comments.keys.count * 50
        project
      }
      .sort_by { |p| p.search_score }
      .reverse
    end
end
