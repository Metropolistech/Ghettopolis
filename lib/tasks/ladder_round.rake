namespace :metropolis do
  task run_ladder: :environment do
    LadderRoundWorker.manage_ladder_round
  end
end
