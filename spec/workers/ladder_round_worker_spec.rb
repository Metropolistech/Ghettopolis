RSpec.describe LadderRoundWorker do

  before(:each) do
    @roundWorker = LadderRoundWorker.new
  end

  describe "#get_last_running_round" do
    context "when there is no round in database" do
      it "create a new round" do
        @roundWorker.get_current_running_round
        expect(@roundWorker.round).to eq(LadderRound.last)
      end
    end

    context "when there is a round in database" do
      before do
        @round_a = LadderRound.create({status: :finished})
        @round_b = LadderRound.create
      end

      it "get the new created round" do
        @roundWorker.get_current_running_round
        expect(@roundWorker.round.id).to eq(@round_b.id)
      end
    end
  end

  describe "#round_is_finished?" do
    before(:each) do
      @round = LadderRound.create
    end

    context "when date is not setted" do
      before { @roundWorker.get_current_running_round }
      it "return false" do
        expect{ @roundWorker.round_is_finished? }.to raise_error
      end
    end

    context "when date is setted to tomorow" do
      before do
        @round.update!({ date: 1.day.from_now })
        @roundWorker.get_current_running_round
      end
      it "return false" do
        expect(@round.date.to_date).to eq(Date.tomorrow)
        expect(@roundWorker.round_is_finished?).to eq(false)
      end
    end

    context "when date is setted to today" do
      before do
        @round.update!({date: Time.now})
        @roundWorker.get_current_running_round
      end
      it "return true" do
        expect(@round.date.to_date).to eq(Date.today)
        expect(@roundWorker.round_is_finished?).to eq(true)
      end
    end
  end

  describe "#get_winner_project" do
    before(:each) do
      @round = LadderRound.create({ date: 1.day.from_now })
      @roundWorker.get_current_running_round
    end

    context "when the round is not finished" do
      it "Throw an error to stop the worker because round is not finished" do
        expect{ @roundWorker.get_winner_project }.
          to raise_error(StandardError, "Stop LadderRoundWorker : Round is not finished.")
      end
    end

    context "when the ladder is empty" do
      before do
        @round = LadderRound.create({ date: Time.now })
        @roundWorker.get_current_running_round
      end
      it "Throw an error to stop the worker because round is not finished" do
        expect{ @roundWorker.get_winner_project }.
          to raise_error(StandardError, "Stop LadderRoundWorker : Ladder is empty.")
      end
    end

    context "when the round is finished and the ladder is full" do
      before do
        user = create_user
        @project = user.create_project! data: {
          title: "Marge's project",
          youtube_id: SecureRandom.hex(2),
          status: "competition"
       }
       @round = LadderRound.create({ date: Time.now })
       @roundWorker.get_current_running_round
      end
      it "set the winner in the round" do
        @roundWorker.get_winner_project
        expect(@roundWorker.round.winner).to eq(@project)
      end
    end
  end

  describe "#get_ladder_state" do
    before do
      @project = create_project status: "competition"
      @round = LadderRound.create({ date: Time.now })
      @roundWorker
        .get_current_running_round
        .get_winner_project
      @project.reload
    end

    it "get the ladder state" do
      @roundWorker.get_ladder_state
      expect(@roundWorker
        .round
        .ladder_state
        .to_json
      ).to eq(Project.populate_ladder.to_json)
    end
  end

  describe "#update_winner_project_status" do
    before do
      @project = create_project status: "competition"
      @round = LadderRound.create({ date: Time.now })
      @roundWorker
        .get_current_running_round
        .get_winner_project
        .update_winner_project_status
      @project.reload
    end

    it "update the project status to : production" do
      expect(@project.status).to eq("production")
    end
  end
end
