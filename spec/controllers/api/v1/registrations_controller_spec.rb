RSpec.describe Api::V1::RegistrationsController, type: :controller do
  render_views

  let(:json) { JSON.parse(response.body) }

  describe "POST /api/register" do

    context "when no user params" do
      before do
        post :create, format: :json, :data => nil
      end

      it "return 400" do
        expect(response.status).to eq(400)
        expect(JSON(response.body)['errors'].blank?).to eq(false)
      end
    end

    context "when user data are setted" do
      before do
        post :create, format: :json, :user => {
          username: "DonutLover",
          firstname: "Homer",
          lastname: "Simpson",
          email: "homer@contact.com",
          password: "KillBart"
        }
      end

      it "return response status 201 and user data" do
        response_data = JSON(response.body)
        user = response_data['data']['user']

        expect(response.status).to eq(201)
        expect(response_data['status']).to eq(201)

        expect(user.blank?).to eq(false)
        expect(user['username'].blank?).to eq(false)
        expect(user['email'].blank?).to eq(false)
      end
    end
  end
end
