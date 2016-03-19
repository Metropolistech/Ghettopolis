class UploadController < ApplicationController
  skip_before_filter :authenticate_user_from_token!
  
  def create
    set_s3_direct_post
  end

  private
  def set_s3_direct_post
    @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/lol.png", success_action_status: '201', acl: 'public-read')
  end
end
