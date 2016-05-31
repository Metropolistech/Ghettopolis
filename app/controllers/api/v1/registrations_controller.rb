class Api::V1::RegistrationsController < ApplicationController
  skip_before_action :authenticate_user_from_token!, only: [:create]
  skip_before_action :verify_user_confirmation!

  before_action :update_register_params, only: [:update]
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

  # PUT /api/register
  def update
    return res_send status: 401 unless current_user.valid_password?(params[:user][:current_password])

    password = params[:user][:password]
    password_confirmation = params[:user][:password_confirmation]

    unless password === password_confirmation
      return res_send data: [PasswordError: "password and confirmation are not the same"], error: true
    end

    is_reseted = current_user
      .reset_password(password, password_confirmation)

    return res_send data: [PasswordError: "password is not valid"], error: true unless is_reseted
    res_send data: current_user, status: 201
  end

  private

    def user_params
      begin
        params.require(:user).permit(:username, :email, :password, :lastname, :firstname)
      rescue
        nil
      end
    end

    def update_register_params
        [:current_password, :password, :password_confirmation]
          .each { |param| params.require(:user).require(param) }
        params.require(:user).permit(:current_password, :password, :password_confirmation)
      rescue => error
        res_send data: [ParameterError: "#{error.param} is empty or missing"], error: true
    end
end
