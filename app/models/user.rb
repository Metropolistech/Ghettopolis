class User < ActiveRecord::Base
  belongs_to :avatar, :class_name => 'Image', :foreign_key => 'image_id'
end
