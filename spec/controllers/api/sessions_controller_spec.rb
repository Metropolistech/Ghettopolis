RSpec.describe Api::SessionsController, type: :controller do
  render_views

  let(:json) { JSON.parse(response.body) }

  describe "POST /api/session" do
    context "When there is no user data" do
      before do
        post :create, format: :json
      end

      it "Return a 404" do
        expect(response.status).to eq(404)
        expect(JSON(response.body)['errors'].blank?).to eq(false)
      end
    end

    context "When there is no email" do
      before do
        post :create, format: :json, :user => { password: "KillBart" }
      end

      it "Return a 404" do
        expect(response.status).to eq(404)
        expect(JSON(response.body)['errors'].blank?).to eq(false)
      end
    end

    context "When there is no password" do
      before do
        post :create, format: :json, :user => { email: "homer@contact.com" }
      end

      it "Return a 404" do
        expect(response.status).to eq(404)
        expect(JSON(response.body)['errors'].blank?).to eq(false)
      end
    end

    context "When user does not exist" do
      before do
        post :create, format: :json, :user => { email: "homer@contact.com", password: "KillBart" }
      end

      it "Return a response data with a status 401 and an error object" do
        response_data = JSON(response.body)

        expect(response.status).to eq(401)
        expect(response_data['status']).to eq(401)
        expect(response_data['errors'].blank?).to eq(false)
      end
    end

    context "When the password is incorrect" do
      before do
        user = User.create(username: "DonutLover", email: "homer@contact.com", password: "KillBart", password_confirmation: "KillBart")
        post :create, format: :json, :user => { email: "homer@contact.com", password: "KillBartRightNow" }
      end

      it "Return a response data with a status 401 and an error object" do
        response_data = JSON(response.body)

        expect(response.status).to eq(401)
        expect(response_data['status']).to eq(401)
        expect(response_data['errors'].blank?).to eq(false)
      end
    end

    context "When user exist and the password is correct" do
      user = nil

      before do
        user = User.create(username: "DonutLover", email: "homer@contact.com", password: "KillBart", password_confirmation: "KillBart")
        post :create, format: :json, :user => { email: user.email, password: user.password }
      end

      it "Return a response data with a status 401 and an error object" do
        response_data = JSON(response.body)
        returned_user = response_data['data']['user']

        expect(response.status).to eq(200)
        expect(response_data['status']).to eq(201)

        expect(returned_user['username']).to eq(user['username'])
        expect(returned_user['email']).to eq(user['email'])

        expect(response_data['data']['token'].blank?).to eq(false)
      end
    end
  end
end
