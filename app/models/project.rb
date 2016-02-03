class Project < ActiveRecord::Base
  include PopulateConcern
  has_many :follow_projects
  has_many :followers, through: :follow_projects, source: :user

  validates :title, :youtube_id, presence: true, uniqueness: true
  validates :author_id, presence: true
  validates :status, inclusion: { in: ["draft", "competition", "production", "released"] }
end
