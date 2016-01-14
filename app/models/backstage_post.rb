class BackstagePost < ActiveRecord::Base
  belongs_to :project
  belongs_to :image
end
