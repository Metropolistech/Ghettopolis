class FollowProject < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates :user, :project, presence: true

  scope :find_follow, -> user_id, project_id { where(user_id: user_id, project_id: project_id) }
end
