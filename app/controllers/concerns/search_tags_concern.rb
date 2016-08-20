module SearchTagsConcern
  extend ActiveSupport::Concern

  include SearchConcern

  def search_tags
    tags = ActsAsTaggableOn::Tag
      .where("LOWER(name) LIKE :query", query: "%#{@q.downcase}%")

    sorted_tags = map_collection(tags) { |tag|
      get_score_by_tag(tag)
    }.sort_by { |t| t[:search_score] }

    remove_search_score_on_sorted_entities(sorted_tags, :tag)
  end

  private
    def get_score_by_tag(tag)
      { tag: tag, search_score:  calc_tag_score(tag) }
    end

    def calc_tag_score(tag)
      score_by_string_diff(tag.name)
    end
end
