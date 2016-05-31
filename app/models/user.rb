class User < ActiveRecord::Base
  include UserConcern

  def create_project!(data: {})
    project = Project.new(data.merge(author_id: self.id))
    project.save
    project
  end

  def update_project!(project_id: nil, data: {})
      _id = project_id

      project = self.is_admin   ?
        Project.find_by_id(_id) :
        self.projects.find_by_id(_id)

      return false if project.blank?
      project.update(data)
      project.save ? project : false
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

  def is_admin?
    self.is_admin
  end

  def serializable_hash(options = nil)
    result = super
    result[:is_confirmed] = self.confirmed_at ? true : false
    result
  end

  def as_json(options={})
    result = super
    result[:avatar] = self.avatar
    result[:skills] = self.skills
    options[:except].each { |attr| result.except!(attr)} if options.has_key?(:except)
    result
  end
end
