require 'serializers/hash_serializer'

class Project < ActiveRecord::Base
  include PopulateConcern
  include LadderConcern

  acts_as_taggable

  serialize :comments, HashSerializer

  has_many :follow_projects
  has_many :followers, through: :follow_projects, source: :user

  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

  validates :youtube_id, uniqueness: true
  validates :released_youtube_id, uniqueness: true, :allow_nil => true
  validates :youtube_id, :title, :author_id, :description, presence: true
  validates :status, inclusion: { in: ["draft", "competition", "production", "released"] }

  validate :check_tag_list!

  scope :in_competion, -> { joins(:author).where(status: :competition) }

  before_create :create_slug

  attr_accessor :followers_count

  def followers_count
    self.followers.count
  end

  def serializable_hash(options = nil)
    result = super
    result[:comments] = format_comments
    result
  end

  def as_json(options={})
    result = super

    result[:author] = self.author
    result[:comments] = format_comments
    result[:tags] = self.tags

    options[:except].each { |attr| result.except!(attr)} if options.has_key?(:except)

    result
  end

  private

  def format_comments
    self.comments.values.sort_by { |comment| comment[:created_at]}
  end

  def create_slug
    self.slug = self.title.parameterize
    self.slug << "-" << SecureRandom.hex(2) unless Project.where(slug: self.slug).blank?
  end

  def check_tag_list!
    errors.add(:tag_list, "A minimum of 3 tags is required.") if self.tag_list.size < 3
  end
end
