module LadderConcern
  extend ActiveSupport::Concern

  class_methods do
    def populate_ladder
      Project
        .in_competion
        .sort_by { |project| project.created_at }
        .reverse
        .sort_by { |project| project.followers_count }
        .reverse
    end
  end
end
