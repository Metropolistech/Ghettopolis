require 'serializers/hash_serializer'
module ProjectConcern
  extend ActiveSupport::Concern

  included do
    include PopulateConcern
    include LadderConcern

    has_many :follow_projects
    has_many :followers, through: :follow_projects, source: :user, dependent: :destroy
    has_one :cover, -> { order created_at: :desc }, :class_name => "Image", as: :img_target, dependent: :destroy

    belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

    validates :youtube_id, uniqueness: true
    validates :released_youtube_id, uniqueness: true, :allow_nil => true
    validates :youtube_id, :title, :author_id, :description, presence: true
    validates :status, inclusion: { in: ["draft", "competition", "production", "released"] }

    default_scope { where(deleted_at: nil) }

    scope :in_competion,
      -> { joins(:author).where(status: :competition) }

    scope :released,
      -> { where(status: "released").order('released_at DESC') }

    scope :search,
      -> (query) {
        where("LOWER(title) LIKE :query OR LOWER(description) LIKE :query ", query: "%#{query.downcase}%")
        .order('created_at DESC')
      }

    serialize :comments, HashSerializer

    acts_as_taggable

    attr_accessor :followers_count
    attr_accessor :image_data
    attr_accessor :ladder_score
    attr_accessor :search_score
  end
end
