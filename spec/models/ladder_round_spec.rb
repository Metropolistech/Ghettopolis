require 'rails_helper'

RSpec.describe LadderRound, type: :model do
  describe "verify LadderRound initial property values" do
    round = LadderRound.create({})

    puts round.to_json
    it "has no winner" do
      expect(round.winner).to eq(nil)
    end

    it "has no ladder_state" do
      expect(round.ladder_state).to eq(nil)
    end

    it "has no date" do
      expect(round.date).to eq(nil)
    end

    it "has a running status" do
      expect(round.status).to eq("running")
    end

    it "has no last_updater" do
      expect(round.last_updater).to eq(nil)
    end
  end
end
