require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "can create a notification" do

    before do
      @user = create_user
      @project = create_project
      @notif = Notification.create(user: @user, notif_duty: @project, notification_type_id: 1)
    end
    it "should create a notification " do
      expect(@notif.notification_type.name).to eq("project_released")
      expect(NotificationType.find_by_id(1).notifications.first).to eq(@notif)
      expect(@user.notifications.last).to eq(@notif)
      expect(@notif.notif_duty).to eq(@project)
    end
  end
end
