class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :projects, foreign_key: "author_id", class_name: "Project"

  belongs_to :avatar, :class_name => 'Image', :foreign_key => 'image_id'

  validates :username, :email, presence: true, uniqueness: true

  validates_format_of :email, with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def create_project!(data: {})
    project = Project.new(data.merge(author_id: self.id))
    project.save ? project : false
  end

  def update_project!(project_id: nil, data: {})
      project = self.projects.find(project_id)
      project.attributes = data
      project.save ? project : false
    rescue
      false
  end

  def delete_project!(project_id)
      project = self.projects.find(project_id)
      project.destroy
    rescue
      false
  end

  # ([String, ...]) => {}
  def populate(attributes)
    return self if attributes.blank?

    to_populate = []
    attributes.each do |attr|
      to_populate.push(attr) if self.respond_to?(attr)
    end

    to_populate.blank? ? self : self.as_json(include: to_populate)
  end
end
