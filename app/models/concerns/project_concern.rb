require 'serializers/hash_serializer'
module ProjectConcern
  extend ActiveSupport::Concern

  included do
    include PopulateConcern
    include LadderConcern

    has_many :follow_projects
    has_many :followers, through: :follow_projects, source: :user

    belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

    validates :youtube_id, uniqueness: true
    validates :released_youtube_id, uniqueness: true, :allow_nil => true
    validates :youtube_id, :title, :author_id, :description, presence: true
    validates :status, inclusion: { in: ["draft", "competition", "production", "released"] }

    scope :in_competion, -> { joins(:author).where(status: :competition) }

    serialize :comments, HashSerializer

    acts_as_taggable
  end
end
