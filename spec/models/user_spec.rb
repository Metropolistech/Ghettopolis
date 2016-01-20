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
end
