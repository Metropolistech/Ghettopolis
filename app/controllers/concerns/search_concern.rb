module SearchConcern
  extend ActiveSupport::Concern

  def get_entities_from_collection(collection, entity_type)
    collection.inject([]) do |obj, item|
      obj.push(item.send(entity_type))
      obj
    end
  end

  def map_collection(collection)
    collection.map do |entity|
      yield entity
    end
  end

  def remove_search_score_on_sorted_entities(collection, property)
    collection.inject([]) do |obj, entity|
      obj.push(entity[property])
      obj
    end
  end

  def score_by_string_diff(str)
    str = "" if str.blank?
    str.downcase.sub(@q.downcase) {}.length * 10
  end
end
