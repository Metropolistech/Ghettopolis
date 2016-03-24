class LadderRound < ActiveRecord::Base
  belongs_to :winner, :class_name => 'Project', :foreign_key => 'winner_id'
  belongs_to :last_updater, :class_name => 'User', :foreign_key => 'last_updater_id'

  validates :status, inclusion: {
    in: ["running", "finished"]
  }

  def self.current_round
    if LadderRound.last && LadderRound.last.status == "running"
      return LadderRound.last
    else
      return LadderRound.create
    end
  end
end
