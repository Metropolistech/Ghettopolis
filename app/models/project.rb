class Project < ActiveRecord::Base
  include ProjectConcern

  before_create :create_slug

  before_update :update_dates_if_status_changed!
  before_update :notify_followers_if_status_changed!

  validate :check_tag_list!

  attr_accessor :followers_count

  @@to_notify_status = ["competition", "production", "released"]

  def update_dates_if_status_changed!
    if @@to_notify_status.include?(self.status) and is_status_changed?
      self[get_method_by_status_name!] = Time.now
    end
  end

  def notify_followers_if_status_changed!
    if @@to_notify_status.include?(self.status) and is_status_changed?
      NotificationWorker
        .notify_project_followers(self.followers, get_notification_id_by_status_name!, self.id)
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
    def is_status?(name)
      self.status === name ? true : false
    end

    def is_status_changed?
      is_status?(self.status) and Project
        .find_by_id(self.id).send(get_method_by_status_name!).blank?
    end

    def get_method_by_status_name!
      case self.status
      when "released"
        :released_at
      when "production"
        :production_at
      when "competition"
        :competition_at
      end
    end

    def get_notification_id_by_status_name!
      case self.status
      when "released"
        1
      when "production"
        2
      when "competition"
        4
      end
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
