class Project < ActiveRecord::Base
  validates :title, :youtube_id, presence: true, uniqueness: true
  validates :author_id, presence: true
  validates :status, inclusion: { in: ["draft", "competition", "production", "released"] }
end
