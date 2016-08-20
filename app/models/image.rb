class Image < ActiveRecord::Base
  belongs_to :img_target, polymorphic: true
  validates :image_name, presence: true
end
