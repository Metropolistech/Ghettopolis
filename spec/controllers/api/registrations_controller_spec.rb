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
        expect(JSON(response.body)['error']).to eq("Missing parameters")
      end
    end

    context "When user params set wrong passwords" do
      before do
        post :create, format: :json, :user => { username: "DonutLover", email: "homer@contact.com", password: "KillBart", password_confirmation: "nothing" }
      end

      it "Return 200 and Object with errors" do
        expect(response.status).to eq(200)
        expect(JSON(response.body)['errors'].blank?).to eq(false)
      end
    end
  end
end
