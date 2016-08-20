module SearchProjectsConcern
  extend ActiveSupport::Concern

  def search_projects
    projects = Project.search(@q)

    sorted_projects = map_collection(projects) { |project|
      get_score_by_project(project)
    }.sort_by { |p| p.search_score }.reverse
  end

  private
    def get_score_by_project(project)
      project.search_score = calc_project_score(project)
      project
    end

    def calc_project_score(project)
      score_by_search_in_title(project) +
      score_by_search_in_description(project) +
      score_by_project_followers(project) +
      score_by_comments_count(project)
    end

    def score_by_search_in_title(project)
      (project.title.downcase.include?(@q) ? 1 : 0 ) * 100
    end

    def score_by_search_in_description(project)
      (project.description.downcase.include?(@q) ? 1 : 0) * 80
    end

    def score_by_project_followers(project)
      project.followers.count * 70
    end

    def score_by_comments_count(project)
      project.comments.keys.count * 50
    end
end
