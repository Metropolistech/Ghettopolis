module PopulateConcern
  extend ActiveSupport::Concern

  # ([String, ...]) => {}
  def populate(attributes)
    return self if attributes.blank?
    to_populate = []
    attributes.each do |attr|
      to_populate.push(attr) if self.respond_to?(attr)
    end
    to_populate.blank? ? self : self.as_json(include: to_populate)
  end
end
