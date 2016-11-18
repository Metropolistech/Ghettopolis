class PasswordController < ApplicationController
  skip_before_action :authenticate_user_from_token!
  skip_before_action :verify_user_confirmation!

  def reset
    user = User.find_by_reset_password_token(params[:reset_token])
    return res_send error: true if user.blank?
  end
end
