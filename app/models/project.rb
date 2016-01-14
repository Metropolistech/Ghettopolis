class Project < ActiveRecord::Base
  belongs_to :author, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :cover, :class_name => 'Image', :foreign_key => 'image_id'
end
