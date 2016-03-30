class Api::V1::LadderRoundController < ApplicationController
  before_filter :required_params, only: [:update]

  # PUT /api/v1/round
  def update
    return res_send status: 401 unless current_user.is_admin
    @round = LadderRound.current_round
    @round.update({ date: ladder_round_params, last_updater: current_user })
    res_send data: @round
  end

  private
    def ladder_round_params
        params.require(:date)
      rescue
        nil
    end

    def required_params
      return res_send data:[ActionRecord: "Missing required project parameter"], error: true unless ladder_round_params
    end
end
