require 'rails_helper'

RSpec.describe User, type: :model do

  describe "validation" do
    user = create_user(save: false);

    describe "requires a valid email." do
      context "If email is invalid" do
        it "cannot validate user" do
          user.email = "homer"
          expect(user.valid?).to eq(false)
          user.email = "homer@lol"
          expect(user.valid?).to eq(false)
          user.email = "homer@.fr"
          expect(user.valid?).to eq(false)
        end
      end

      context "If email is valid" do
        it "can validate user" do
          user.email = "me@contact.com"
          expect(user.valid?).to eq(true)
        end
      end
    end

    describe "requires a valid password_confirmation." do
      context "If password & confirmation are the same" do
        it "cannot validate user" do
          user.password_confirmation = "azerty"
          expect(user.valid?).to eq(false)
        end
      end

      context "If password & confirmation are not the same" do
        it "can validate user" do
          user.password = "KillBart"
          user.password_confirmation = "KillBart"
          expect(user.valid?).to eq(true)
        end
      end
    end

    describe "requires unique username." do
      context "If record have an already taken username" do
        it "cannot validate user" do
          user.email = "another@email.com"
          expect(user.valid?).to eq(true)

          user_saved = create_user

          expect(user.username).to eq(user_saved.username)
          expect(user.valid?).to eq(false)
        end
      end

      context "If record have an unique username" do
        it "can validate user" do
          user_saved = create_user
          user.username = "anotherUsername"
          expect(user.username).not_to eq(user_saved.username)
          expect(user.valid?).to eq(true)
        end
      end
    end

    describe "requires unique email" do
      context "If record have an already taken email" do
        it "cannot save user" do
          user.email = "homer@contact.com"
          expect(user.valid?).to eq(true)

          user_saved = create_user

          expect(user.email).to eq(user_saved.email)
          expect(user.valid?).to eq(false)
        end
      end

      context "If record have an unique email" do
        it "can save user" do
          user_saved = create_user
          user.email = "another@email.com"
          expect(user.email).not_to eq(user_saved.email)
          expect(user.valid?).to eq(true)
        end
      end
    end
  end

  describe "#create_project" do
    context "when title is setted" do
      it "return the project object" do
        user = create_user
        data = { title: "new project" }
        expect(user.create_project!(data: data)).to be_a Project
        expect(user.projects.count).to eq(1)
      end
    end

    context "when title is not setted" do
      it "return false to say that project is not created" do
        user = create_user
        expect(user.create_project!).to eq(false)
        expect(user.projects.count).to eq(0)
      end
    end

    context "when title is already taken" do
      it "return false to say that project is not created" do
        user_a = create_user

        user_b = create_user(data: {
          username: "MargeSimps",
          email: "marge@contact.com"
        })

        user_a.create_project!(data: { title: "hello" })

        expect(user_b.create_project!(data: { title: "hello" })).to eq(false)
        expect(user_b.projects.count).to eq(0)
      end
    end
  end

  describe "#update_project" do
    context "when user want update his project" do
      user = nil
      project = nil

      before do
        user = create_user
        project = user.create_project!(data: { title: "new project" })
      end

      it "return the updated project" do
        expect(project.title).to eq("new project")

        updated_project = user.update_project!(project_id: project.id, data: { title: "another title" })

        expect(updated_project.title).to eq("another title")
        expect(updated_project.id).to eq(project.id)
      end
    end

    context "when user want update his project" do
      user = nil
      project = nil

      before do
        user = create_user
        user_b = create_user(data: { username: "MargeSimps", email: "marge@contact.com" })
        project = user_b.create_project!(data: { title: "new project" })
      end

      it "return false to say that the project were not updated" do
        updated_project = user.update_project!(project_id: project.id, data: { title: "another title" })
        expect(updated_project).to eq(false)
      end
    end
  end

  describe "#delete_project" do
    it "can delete a project" do
      user = create_user
      project = user.create_project!(data: { title: "new project" })
      expect(user.projects.count).to eq(1)

      user.delete_project!(project.id)
      expect(user.projects.count).to eq(0)
    end

    it "cannot delete a project from other users" do
      user_a = create_user
      user_b = create_user(data: { username: "MargeSimps", email: "marge@contact.com" })

      project_b = user_b.create_project!(data: { title: "hello" })

      expect(user_a.delete_project!(project_b.id)).to eq(false)
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

    it "cannot remove a project from competition" do
      pending("Awaiting instructions to implement this test")
    end

    it "can delete an in_competition project" do
      pending("Awaiting instructions to implement this test")
    end

    it "can get projects in_competition" do
      pending("Awaiting instructions to implement this test")
    end

    it "can get projects not in_competition" do
      pending("Awaiting instructions to implement this test")
    end

    it "can get all projects" do
      pending("Awaiting instructions to implement this test")
    end

    # describe "#follow_project & #unfollow_project" do
    #   user_a = create_user
    #   user_b = create_user(data: {
    #     username: "MargeSimps",
    #     email: "marge@contact.com"
    #   })
    #
    #   project = user_b.create_project!(data: { title: "Marge's project" })
    #
    #   it "can follow a project" do
    #     user_a.follow_project!(project.id)
    #     expect(user_a.followed_projects.count).to eq(1)
    #   end
    #
    #   it "can unfollow a project" do
    #     user_a.unfollow_project!(project.id)
    #     expect(user_a.followed_projects.count).to eq(0)
    #   end
    # end
  end

  describe "self methods" do
    it "can get his personnal data" do
      pending("Awaiting instructions to implement this test")
    end

    it "can update his data" do
      pending("Awaiting instructions to implement this test")
    end

    it "can get his followers" do
      pending("Awaiting instructions to implement this test")
    end

    it "can get his followings" do
      pending("Awaiting instructions to implement this test")
    end

    it "can get his followings projects" do
      pending("Awaiting instructions to implement this test")
    end
  end
end
