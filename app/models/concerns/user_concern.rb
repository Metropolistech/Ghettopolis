module UserConcern
  extend ActiveSupport::Concern

  included do
    include PopulateConcern

    acts_as_taggable_on :skills

    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable, :confirmable

    has_many :follow_projects
    has_many :followed_projects, -> { where deleted_at: nil }, through: :follow_projects, source: :project
    has_many :projects, -> { where deleted_at: nil }, foreign_key: "author_id", class_name: "Project"
    has_many :notifications, -> {
      select(:id, :notification_type, :seen_at, :created_at, :is_read)
      .order("created_at DESC")
      .limit(10)
    }

    has_one :avatar, -> { order created_at: :desc }, :class_name => "Image", as: :img_target, dependent: :destroy

    validates :username, presence: true, uniqueness: { case_sensitive: false }
    validates :email, presence: true, uniqueness: true
    validates_format_of :email, with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

    scope :find_by_lower_username,
      -> (username) { where("lower(username) = ?", username.downcase) }

    attr_accessor :image_data
  end
end
