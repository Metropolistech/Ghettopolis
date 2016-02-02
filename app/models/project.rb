class Project < ActiveRecord::Base
  has_many: :followers, through: :follow_projects
  
  validates :title, :youtube_id, presence: true, uniqueness: true
  validates :author_id, presence: true
  validates :status, inclusion: { in: ["draft", "competition", "production", "released"] }
end
