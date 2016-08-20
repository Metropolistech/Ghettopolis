require 'rails_helper'

RSpec.describe User, type: :model do

  describe "needs a valid email" do
    before do
      @user = create_user
    end

    context "If email is invalid" do
      it "cannot validate user" do
        @user.email = "homer"
        expect(@user.valid?).to eq(false)
        @user.email = "homer@lol"
        expect(@user.valid?).to eq(false)
        @user.email = "homer@.fr"
        expect(@user.valid?).to eq(false)
      end
    end

    context "If email is valid" do
      it "can validate user" do
        @user.email = "me@contact.com"
        expect(@user.valid?).to eq(true)
      end
    end
  end

  describe "need unique username." do
    before do
      @user_a = create_user
      @user_b = create_user
    end

    context "If record have an already taken username" do
      before do
        @user_b.username = @user_a.username
      end

      it "cannot validate user" do
        expect(@user_a.username).to eq(@user_b.username)
        expect(@user_b.valid?).to eq(false)
      end
    end

    context "If record have an unique username" do
      before do
        @user_a.username = "anotherName"
      end
      it "can validate user" do
        expect(@user_a.username).not_to eq(@user_b.username)
        expect(@user_a.valid?).to eq(true)
      end
    end
  end

  describe "requires unique email" do
    before do
      @user_a = create_user
      @user_b = create_user
      @user_b.email = @user_a.email
    end

    context "If record have an already taken email" do
      it "cannot save user" do
        expect(@user_a.email).to eq(@user_b.email)
        expect(@user_b.valid?).to eq(false)
      end
    end

    context "If record have an unique email" do
      before do
        @user_b.email = "another@email.com"
      end

      it "can save user" do
        expect(@user_a.email).not_to eq(@user_b.email)
        expect(@user_b.valid?).to eq(true)
      end
    end
  end

  describe "#create_project!" do
    context "when title is setted" do
      it "return the project object" do
        user = create_user
        expect(user.create_random_project).to be_a Project
        expect(user.projects.count).to eq(1)
      end
    end

    context "when title is not setted" do
      it "return project with errors" do
        user = create_user
        expect(user.create_project!.errors.blank?).to eq(false)
        expect(user.projects.count).to eq(0)
      end
    end
  end

  describe "#update_project!" do
    context "when user want update his project" do
      before do
        @user = create_user
        @project = @user.create_random_project(title: "new project")
        @updated_project = @user
          .update_project!(project_id: @project.id, data: { title: "another title" })
      end

      it "return the updated project" do
        expect(@project.title).to eq("new project")
        expect(@updated_project.title).to eq("another title")
        expect(@updated_project.id).to eq(@project.id)
      end
    end

    context "when user want update his project" do
      user = nil
      project = nil

      before do
        user = create_user
        user_b = create_user
        project = user_b.create_project!(data: { title: "new project", youtube_id: "1" })
      end

      it "return false to say that the project were not updated" do
        updated_project = user.update_project!(project_id: project.id, data: { title: "another title" })
        expect(updated_project).to eq(false)
      end
    end
  end

  describe "#follow_project!" do

    before(:each) do
      @user_a = create_user
      @user_b = create_user
      @project = @user_b.create_random_project
    end

    it "can follow a project" do
      expect(@user_a.follow_project!(@project.id)).to eq(true)
      expect(@user_a.followed_projects.count).to eq(1)
    end

    it "cannot follow a non existing project" do
      expect(@user_a.follow_project!(10000)).to eq(false)
      expect(@user_a.followed_projects.count).to eq(0)
    end
  end

  describe "#unfollow_project!" do

    before(:each) do
      @user_a = create_user
      @user_b = create_user
      @project = @user_b.create_random_project
      @user_a.follow_project!(@project.id)
    end

    it "can unfollow a project" do
      expect(@user_a.followed_projects.count).to eq(1)
      expect(@user_a.unfollow_project!(@project.id)).to eq(true)
      expect(@user_a.followed_projects.count).to eq(0)
    end

    it "cannot unfollow a non existing project" do
      expect(@user_a.unfollow_project!(30)).to eq(false)
      expect(@user_a.followed_projects.count).to eq(1)
    end
  end

  describe "project methods" do
    #
    # it "can put a project in competition" do
    #   user = create_user
    #   project_a = user.create_project!(data: { title: "new project" })
    #   project_b = user.create_project!(data: { title: "second project" })
    #   user.in_competition_mode!(project_b.id)
    #   expect(user.projects).to eq(2)
    #   expect(user.in_competition_projets).to eq(1)
    # end

    xit "cannot remove a project from competition" do
    end

    xit "can delete an in_competition project" do
    end

    xit "can get projects in_competition" do
    end

    xit "can get projects not in_competition" do
    end

    xit "can get all projects" do
    end
  end

  describe "self methods" do
    xit "can get his personnal data" do
    end

    xit "can update his data" do
    end

    xit "can get his followers" do
    end

    xit "can get his followings" do
    end

    xit "can get his followings projects" do
    end
  end
end
