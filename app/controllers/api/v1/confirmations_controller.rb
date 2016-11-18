class Api::V1::ConfirmationsController < ApplicationController
  skip_before_action :authenticate_user_from_token!, only: [:confirm]
  skip_before_action :verify_user_confirmation!

  before_action :confirmations_params, only: [:confirm]

  # POST /api/v1/confirmation
  def confirm
    user = User.find_by_confirmation_token(params[:confirmation_token])

    if user
      user.confirm
      user.save
    end

    redirect_to "http://#{ENV['APP_FRONT_DOMAIN']}"
  end

  # GET /api/v1/confirmation/resend
  def resend
    current_user.send_confirmation_instructions if current_user.confirmed_at.blank?
    res_send data: { message: "OK" }
  end

  private

  def confirmations_params
      params.require(:confirmation_token)
    rescue => error
      res_send data: [ParameterError: "#{error.param} is empty or missing"], error: true
  end
end
