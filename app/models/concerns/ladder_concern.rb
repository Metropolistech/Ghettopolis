module LadderConcern
  extend ActiveSupport::Concern

  class_methods do
    def populate_ladder
      self
        .available
        .in_competion
        .map { |project|
          project
          .ladder_score =
            score_by_date(project) +
            score_by_comments(project) +
            score_by_votes(project) +
            score_by_author_created_at(project)
          project
        }
        .sort_by { |project| project.ladder_score }
        .reverse
    end

    private
      def score_by_date(project)
        - (Date.today - project.competition_at.to_date).to_i * 10
      end

      def score_by_comments(project)
        project.comments.keys.count * 5
      end

      def score_by_votes(project)
        project.followers_count * 15
      end

      def score_by_author_created_at(project)
        (Date.today - project.author.created_at.to_date).to_i * 2
      end
  end
end
