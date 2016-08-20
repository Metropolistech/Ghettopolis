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

  def index
    notifications = Notification
      .where(user_id: current_user.id)
      .order('created_at DESC')

    params[:page] = 1 if params[:page].to_i == 0

    res_send data: {
      total_pages: get_total_pages(notifications),
      current_page: params[:page].to_i || 1,
      notifications: notifications.paginate(page: params[:page], per_page: 10)
    }
  end

  private
    def get_total_pages(collection)
      collection.size/10 + 1
    end
end
