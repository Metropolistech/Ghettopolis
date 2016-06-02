class Api::V1::ConfirmationsController < ApplicationController
  skip_before_action :authenticate_user_from_token!
  skip_before_action :verify_user_confirmation!

  before_action :confirmations_params

  # POST /api/v1/confirmations
  def confirm
    user = User.find_by_confirmation_token(params[:confirmation_token])

    if user
      user.confirm
      user.save
    end

    redirect_to "http://#{ENV['APP_FRONT_DOMAIN']}"
  end

  private

  def confirmations_params
      params.require(:confirmation_token)
    rescue => error
      res_send data: [ParameterError: "#{error.param} is empty or missing"], error: true
  end
end
