class Api::RegistrationsController < Api::BaseController
  skip_before_filter :authenticate_user_from_jwt!

  # POST /api/register
  def create
    return render json: { errors: { message: "Missing parameters" } }, status: 404 if user_params.blank?
    @user = User.new(user_params)
    @auth_token = JsonWebToken.encode(JsonWebToken.create_user_payload(@user)) if @user.save
  end

  private

  def user_params
    begin
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    rescue
      nil
    end
  end
end
