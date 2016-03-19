class Api::V1::ConfirmationsController < ApplicationController
  skip_before_filter :authenticate_user_from_token!
  skip_before_filter :verify_user_confirmation!

  def confirm
    return res_send status: 403 unless confirmations_params

    user = User.find_by_confirmation_token(params[:confirmation_token])

    if user
      user.confirm
      return res_send status: 202, data: user if user.save
    end

    return res_send status: 401
  end

  private

  def confirmations_params
      params.require(:confirmation_token)
    rescue
      nil
  end
end
