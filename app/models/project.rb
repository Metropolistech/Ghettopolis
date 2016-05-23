class Project < ActiveRecord::Base
  include ProjectConcern

  before_create :create_slug
  validate :check_tag_list!

  attr_accessor :followers_count

  def followers_count
    self.followers.count
  end

  def serializable_hash(options = nil)
    result = super
    result[:comments] = format_comments
    result
  end

  def as_json(options={})
    result = super
    result[:author] = self.author
    result[:comments] = format_comments
    result[:tags] = self.tags
    result[:cover] = self.cover.last

    options[:except].each { |attr| result.except!(attr)} if options.has_key?(:except)

    result
  end

  private
    def format_comments
      self.comments.values.sort_by { |comment| comment[:created_at]}
    end

    def create_slug
      self.slug = self.title.parameterize
      self.slug << "-" << SecureRandom.hex(2) unless Project.where(slug: self.slug).blank?
    end

    def check_tag_list!
      errors.add(:tag_list, "A minimum of 3 tags is required.") if self.tag_list.size < 3
    end
end
