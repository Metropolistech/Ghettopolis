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
    if round_is_finished
      @round.update({ winner: Project.populate_ladder.first }) unless Project.populate_ladder.blank?
    end
    # Stop task
  end

  def update_winner_project_status

  end

  def round_is_finished?
    return @round.date.to_date == Date.today unless @round.date.blank?
    false
  end

  def send_mail_to_winner_project_author

  end

  def close_round

  end

  def open_round

  end

# GET winner,
# SET winner.status to: :in_production
# SEND Mail to winner.author
# GET Ladder data
# EXPORT Model.entry to: CSV
# SEND CSV to: admins
# CREATE new LadderRound
end
