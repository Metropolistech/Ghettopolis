module LadderConcern
  extend ActiveSupport::Concern

  class_methods do
    def populate_ladder
      self
        .available
        .in_competion
        .map { |project|
          @project = project
          @project.ladder_score = 1000 + calc_score
          @project
        }
        .sort_by { |project| project.ladder_score }
        .reverse
    end

    # An util to get the difference in days between today and a specific date
    def get_date_difference(date)
      (Date.today - date).to_i
    end

    private
      def calc_score
        score_by_days +
        score_by_weeks +
        score_by_comments +
        score_by_votes +
        score_by_author_created_at +
        score_by_author_projects +
        score_by_tag_list
      end

      def score_by_days
        - get_date_difference(@project.competition_at.to_date) * 4
      end

      def score_by_weeks
        - (get_date_difference(@project.competition_at.to_date) / 7) * 50
      end

      def score_by_comments
        @project.comments.keys.count * 5
      end

      def score_by_votes
        @project.followers_count * 40
      end

      def score_by_author_created_at
        (get_date_difference(@project.author.created_at.to_date) / 30) * 2
      end

      def score_by_author_projects
        @project.author.projects.count * 2
      end

      def score_by_tag_list
        - (@project.tag_list.count * 0.25) * 20
      end
  end
end
