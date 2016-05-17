module UserConcern
  extend ActiveSupport::Concern

  included do
    include PopulateConcern

    acts_as_taggable_on :skills

    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable, :confirmable

    has_many :follow_projects
    has_many :followed_projects, through: :follow_projects, source: :project
    has_many :projects, foreign_key: "author_id", class_name: "Project"

    belongs_to :avatar, :class_name => 'Image', :foreign_key => 'image_id'

    validates :username, presence: true, uniqueness: { case_sensitive: false }
    validates :email, presence: true, uniqueness: true
    validates_format_of :email, with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

    scope :find_by_lower_username,
      -> (username) { where("lower(username) = ?", username.downcase) }
  end
end
