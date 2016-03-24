class LadderRoundWorker

  attr_accessor :round

  def run_job

  end

  def get_current_running_round
    if LadderRound.last && LadderRound.last.status == "running"
      @round = LadderRound.last
    else
      @round = LadderRound.create
    end
    self
  end

  def get_winner_project
    raise_error message: "Round is not finished." unless round_is_finished?

    @ladder = Project.populate_ladder
    raise_error message: "Ladder is empty." if @ladder.blank?

    @round.update({ winner: @ladder.first })
    return self
  end

  def get_ladder_state
    @round.update({ ladder_state: @ladder.to_json })
  end

  def update_winner_project_status
    @round.winner.update({ status: "production" })
  end

  def round_is_finished?
    return @round.date.to_date == Date.today unless @round.date.blank?
    false
  end

  def send_mail_to_winner_project_author

  end

  def close_current_round

  end

  def open_new_round

  end

  def raise_error(message: nil)
  raise StandardError, "Stop LadderRoundWorker : #{message}"
  end

# GET winner,
# SET winner.status to: :in_production
# SEND Mail to winner.author
# GET Ladder data
# EXPORT Model.entry to: CSV
# SEND CSV to: admins
# CREATE new LadderRound
end
