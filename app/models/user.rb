class User < ActiveRecord::Base
  include PopulateConcern
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :follow_projects
  has_many :followed_projects, through: :follow_projects, source: :project
  has_many :projects, foreign_key: "author_id", class_name: "Project"

  belongs_to :avatar, :class_name => 'Image', :foreign_key => 'image_id'

  validates :username, :email, presence: true, uniqueness: true

  validates_format_of :email, with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def create_project!(data: {})
    project = Project.new(data.merge(author_id: self.id))
    project.save
    project
  end

  def update_project!(project_id: nil, data: {})
      project = self.projects.find(project_id)
      project.attributes = data
      project.save
      project
    rescue
      false
  end

  def delete_project!(project_id)
      project = self.projects.find(project_id)
      project.destroy
    rescue
      false
  end

  def follow_project!(project_id)
    follow = FollowProject.new(user: self, project_id: project_id)
    follow.save
  end

  def unfollow_project!(project_id)
      follow = self.follow_projects.find_by_project_id(project_id)
      return follow.destroy ? true : false if follow
      false
  end
end
