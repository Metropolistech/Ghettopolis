class Api::V1::NotificationsController < ApplicationController
  skip_before_action :verify_user_confirmation!

  def update
    to_read = params[:notifications].split(',')

    to_read.each do |id|
      Notification
        .find_by_id(id)
        .update_attribute("is_read", true)
    end

    res_send status: 204
  end
end
