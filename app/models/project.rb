require 'serializers/hash_serializer'

class Project < ActiveRecord::Base
  include PopulateConcern

  serialize :comments, HashSerializer

  has_many :follow_projects
  has_many :followers, through: :follow_projects, source: :user

  validates :title, :youtube_id, presence: true, uniqueness: true
  validates :author_id, presence: true
  validates :status, inclusion: { in: ["draft", "competition", "production", "released"] }

  def as_json(options={})
    result = super
    result[:comments] = format_comments
    result
  end

  private

  def format_comments
    self.comments.values.sort_by { |comment| comment[:created_at]}
  end
end
