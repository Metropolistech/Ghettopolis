class Notification < ActiveRecord::Base
  belongs_to :user

  before_save :update_seen_at_if_is_read!

  def update_seen_at_if_is_read!
    self.seen_at = Time.now if is_read? && has_never_been_read?
  end

  def serializable_hash(options = nil)
    result = super
    result[:payload] = {
      project: Project.find_by_id(result["project_id"]).as_json
    }
    result
  end

  private
    def is_read?
      self.is_read
    end

    def has_never_been_read?
      Notification.find_by_id(self.id).seen_at === nil
    end
end
