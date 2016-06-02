class LadderRoundWorker

  attr_accessor :round

  def self.manage_ladder_round
      LadderRoundWorker.new.run_job
    rescue Exception => e
      ReportMailer
        .send_worker_fail_report(message: e.message)
        .deliver_now
      print "Stop LadderRoundWorker : #{e.message}"
  end

  def run_job
    self
      .get_current_running_round
      .get_winner_project
      .update_winner_project_status
      .get_ladder_state
      .notify_all_winner_followers
      .email_all_winner_followers
      .close_current_round
      .open_new_round
  end

  def get_current_running_round
    @round = LadderRound.current_round
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
    self
  end

  def update_winner_project_status
    @round.winner.update({ status: "production" })
    self
  end

  def round_is_finished?
    return @round.date.to_date == Date.today unless @round.date.blank?
    raise_error message: "Round's end date is not defined."
  end

  def send_mail_to_winner_project_author
    CongratsWinnerMailer
      .send_congrats(to: @round.winner.author.email)
      .deliver_later
    self
  end

  def notify_all_winner_followers
    NotificationWorker
      .notify_project_followers(@round.winner.followers, 3, @round.winner.id)
  end

  def email_all_winner_followers
    @round.winner.followers.each do |user|
      MetropolisMailer
        .send_mail_to_winner_followers(to: user.email, project: @round.winner)
        .deliver_later
    end
  end

  def close_current_round
    @round.update({ status: "finished" })
    self
  end

  def open_new_round
    LadderRound.create
  end

  def raise_error(message: nil)
  raise StandardError, "Stop LadderRoundWorker : #{message}"
  end
end
