RSpec.describe Api::RegistrationsController, type: :controller do
  render_views

  let(:json) { JSON.parse(response.body) }

  describe "POST /api/register" do
    context "When there is no user params" do
      before do
        post :create, format: :json, :data => nil
      end

      it "Return a 404" do
        expect(response.status).to eq(404)
        expect(JSON(response.body)['errors'].blank?).to eq(false)
      end
    end

    context "When user params set wrong passwords" do
      before do
        post :create, format: :json, :user => { username: "DonutLover", email: "homer@contact.com", password: "KillBart", password_confirmation: "nothing" }
      end

      it "Return a response with a status 401 and an object with errors" do
        expect(response.status).to eq(200)
        expect(JSON(response.body)['status']).to eq(401)
        expect(JSON(response.body)['errors'].blank?).to eq(false)
      end
    end

    context "When all user data are setted" do
      before do
        post :create, format: :json, :user => { username: "DonutLover", email: "homer@contact.com", password: "KillBart", password_confirmation: "KillBart" }
      end

      it "Return a response with a status 201 and the user data" do
        response_data = JSON(response.body)
        user = response_data['data']['user']

        expect(response.status).to eq(200)
        expect(response_data['status']).to eq(201)

        expect(user.blank?).to eq(false)
        expect(user['username'].blank?).to eq(false)
        expect(user['email'].blank?).to eq(false)
      end
    end
  end
end
