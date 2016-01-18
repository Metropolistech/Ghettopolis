class Api::RegistrationsController < Api::BaseController
  skip_before_filter :authenticate_user_from_jwt!

  def create
    @user = User.new(user_params)
    @auth_token = JsonWebToken.encode("user_email" => @user.email) if @user.save
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
