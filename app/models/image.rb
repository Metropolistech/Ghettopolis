class Image < ActiveRecord::Base
  belongs_to :img_target, polymorphic: true
end
