class Api::RegistrationsController < Api::BaseController
  skip_before_filter :authenticate_user_from_jwt!

  # POST /api/register
  def create
    if user_params.blank?
      render json: { error: "Missing parameters" }, status: 404
    end
    @user = User.new(user_params)
    @auth_token = JsonWebToken.encode("user_email" => @user.email) if @user.save
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
