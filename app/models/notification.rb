class Notification < ActiveRecord::Base
  belongs_to :user

  before_save :update_seen_at_if_is_read!

  def update_seen_at_if_is_read!
    self.seen_at = Time.now if is_read? && has_never_been_read?
  end

  private
    def is_read?
      self.is_read
    end

    def has_never_been_read?
      Notification.find_by_id(self.id).seen_at === nil
    end
end
