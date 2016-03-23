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
        expect(@roundWorker.round_is_finished?).to eq(false)
      end
    end

    context "when date is setted to tomorow" do
      before do
        @round.update!({date: 1.day.from_now})
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
end
