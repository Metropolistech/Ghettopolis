class Api::V1::LadderRoundController < ApplicationController
  before_filter :required_params, only: [:update]

  # PUT /api/v1/round
  def update
    return res_send status: 401 unless current_user.is_admin
    @round = LadderRound.current_round
    time = timestamp_to_date
    @round.update({ date: time, last_updater: current_user })
    res_send data: @round
  end

  private
    def ladder_round_params
        params.require(:date)
      rescue
        nil
    end

    def required_params
      return res_send data:[ActionRecord: "Missing required date parameter"], error: true unless ladder_round_params
    end

    def timestamp_to_date
      Time.at(ladder_round_params)
    end
end
