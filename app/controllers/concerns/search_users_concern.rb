module SearchUsersConcern
  extend ActiveSupport::Concern

  def search_users
    users_from_projects = get_entities_from_collection(@projects, :author)
    users = User.search(@q)

    users & users_from_projects unless users_from_projects.blank?

    sorted_users = map_collection(users) { |user|
      get_score_by_user(user)
    }.sort_by { |user| user.search_score }.reverse
  end

  private
    def get_score_by_user(user)
      user.search_score = calc_user_score(user)
      user
    end

    def calc_user_score(user)
      - score_by_string_diff(user.username) +
      score_by_projects(user)
    end

    def score_by_projects(user)
      user.projects.count * 20
    end
end
