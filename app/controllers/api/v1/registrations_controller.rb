class Api::V1::RegistrationsController < ApplicationController
  skip_before_filter :authenticate_user_from_token!

  # POST /api/register
  def create
    return res_send data: [createRegistration: "Missing required user parameter"], error: true if user_params.blank?

    @user = User.new(user_params)
    if @user.save
      @auth_token = JsonWebToken.encode(JsonWebToken.create_user_payload(@user))
      return res_send data: { user: @user, token: @auth_token }, status: 201
    end

    res_send data: @user.errors.messages, error: true
  end

  private

  def user_params
    begin
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    rescue
      nil
    end
  end
end
