require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "validation" do

    describe "require a unique title" do

    end

    describe "require author_id" do

    end

    describe "require a status include in [draft, competition, production, released]" do

    end
  end

  describe "#followers" do
    user_a = user_b = project = nil
    before(:each) do
      user_a = create_user
      user_b = create_user data: { username: "MargeSimps", email: "marge@contact.com" }
      project = user_a.create_project! data: { title: "Marge's project", youtube_id: "1" }
    end

    it "can get the followers" do
      expect(project.followers.count).to eq(0)
      user_b.follow_project! project.id
      expect(project.followers.count).to eq(1)
    end
  end
end
