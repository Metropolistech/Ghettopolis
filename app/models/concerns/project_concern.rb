require 'serializers/hash_serializer'
module ProjectConcern
  extend ActiveSupport::Concern

  included do
    include PopulateConcern
    include LadderConcern

    has_many :follow_projects
    has_many :followers, through: :follow_projects, source: :user
    has_one :cover, -> { order created_at: :desc },, :class_name => "Image", as: :img_target, dependent: :destroy

    belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

    validates :youtube_id, uniqueness: true
    validates :released_youtube_id, uniqueness: true, :allow_nil => true
    validates :youtube_id, :title, :author_id, :description, presence: true
    validates :status, inclusion: { in: ["draft", "competition", "production", "released"] }

    scope :in_competion, -> { joins(:author).where(status: :competition) }

    scope :available, -> { where(deleted_at: nil) }

    serialize :comments, HashSerializer

    acts_as_taggable

    attr_accessor :image_data
  end
end
