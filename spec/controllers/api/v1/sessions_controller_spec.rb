RSpec.describe Api::V1::SessionsController, type: :controller do
  render_views

  let(:json) { JSON.parse(response.body) }

  describe "POST /api/session" do

    context "when no request params" do
      before do
        post :create, format: :json
      end

      it "return 404" do
        expect(response.status).to eq(404)
        expect(JSON(response.body)['errors'].blank?).to eq(false)
      end
    end

    context "when no user email" do
      before do
        post :create, format: :json, :user => { password: "KillBart" }
      end

      it "return 404" do
        expect(response.status).to eq(404)
        expect(JSON(response.body)['errors'].blank?).to eq(false)
      end
    end

    context "when no user password" do
      before do
        post :create, format: :json, :user => { email: "homer@contact.com" }
      end

      it "return 404" do
        expect(response.status).to eq(404)
        expect(JSON(response.body)['errors'].blank?).to eq(false)
      end
    end

    context "when user does not exist" do
      before do
        post :create, format: :json, :user => { email: "homer@contact.com", password: "KillBart" }
      end

      it "return data status 401 and error object" do
        response_data = JSON(response.body)

        expect(response.status).to eq(401)
        expect(response_data['status']).to eq(401)
        expect(response_data['errors'].blank?).to eq(false)
      end
    end

    context "when user password is incorrect" do
      before do
        create_user do
          post :create, format: :json, :user => { email: "homer@contact.com", password: "KillBartRightNow" }
        end
      end

      it "return data status 401 and error object" do
        response_data = JSON(response.body)

        expect(response.status).to eq(401)
        expect(response_data['status']).to eq(401)
        expect(response_data['errors'].blank?).to eq(false)
      end
    end

    context "When user and password are good" do
      user = nil

      before do
        create_user do
          post :create, format: :json, :user => { email: @user.email, password: @user.password }
        end
      end

      it "return data status 201 and user object with new token" do
        response_data = JSON(response.body)
        returned_user = response_data['data']['user']

        expect(response.status).to eq(200)
        expect(response_data['status']).to eq(201)

        expect(returned_user['username']).to eq(@user['username'])
        expect(returned_user['email']).to eq(@user['email'])

        expect(response_data['data']['token'].blank?).to eq(false)
      end
    end

    context "when open session with available token" do
      user = nil
      token = nil

      before do
        create_user do
          post :create, format: :json, :user => { email: @user.email, password: @user.password }
          token = JSON(response.body)['data']['token']
          post :create, format: :json, :token => token.to_s
        end
      end

      it "return data status 201 and user object with same token" do
        response_data = JSON(response.body)
        returned_user = response_data['data']['user']

        expect(response.status).to eq(200)
        expect(response_data['status']).to eq(201)

        expect(returned_user['username']).to eq(@user['username'])
        expect(returned_user['email']).to eq(@user['email'])

        expect(response_data['data']['token']).to eq(token)
      end
    end
  end
end
