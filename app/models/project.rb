class Project < ActiveRecord::Base
  include ProjectConcern
  include NotificationConcern

  before_create :create_slug

  before_save :update_dates_if_status_changed!

  before_save :notify_followers_if_status_changed!

  validate :check_tag_list!

  attr_accessor :followers_count

  def update_dates_if_status_changed!
    self.released_at = Time.now if is_status_released? and self.released_at === nil
    self.production_at = Time.now if is_status_production? and self.production_at === nil
  end

  def notify_followers_if_status_changed!
    if is_status_released? or is_status_production?
      notify_project_followers self.followers, 1, self
    end
  end

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
    result[:cover] = self.cover

    options[:except].each { |attr| result.except!(attr)} if options.has_key?(:except)

    result
  end

  private
    def is_status_released?
      self.status === "released" ? true : false
    end

    def is_status_production?
      self.status === "production" ? true : false
    end

    def format_comments
      self.comments.values
        .sort_by { |comment| comment[:created_at] }
        .select { |comment| comment[:deleted_at].blank? }
    end

    def create_slug
      self.slug = self.title.parameterize
      self.slug << "-" << SecureRandom.hex(2) unless Project.where(slug: self.slug).blank?
    end

    def check_tag_list!
      errors.add(:tag_list, "A minimum of 3 tags is required.") if self.tag_list.size < 3
    end
end
