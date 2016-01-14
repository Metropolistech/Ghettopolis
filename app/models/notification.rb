class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :backstage_post
end
