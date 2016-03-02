require 'serializers/hash_serializer'

class Project < ActiveRecord::Base
  include PopulateConcern
  include LadderConcern

  acts_as_taggable

  serialize :comments, HashSerializer

  has_many :follow_projects
  has_many :followers, through: :follow_projects, source: :user

  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

  validates :title, :youtube_id, presence: true, uniqueness: true
  validates :author_id, presence: true
  validates :status, inclusion: { in: ["draft", "competition", "production", "released"] }

  scope :in_competion, -> { joins(:author).where(status: :competition) }

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

    result[:followers_count] = self.followers_count
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
end
