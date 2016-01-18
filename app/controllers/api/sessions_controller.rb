class Api::SessionsController < Api::BaseController
  skip_before_filter :authenticate_user_from_jwt!
  before_filter :ensure_params_exist

  def create
    @user = User.find_for_database_authentication(email: user_params[:email])
    return invalid_user unless @user
    return invalid_login_attempt unless @user.valid_password?(user_params[:password])
    @auth_token = JsonWebToken.encode("user_email" => @user.email)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def ensure_params_exist
    if user_params[:email].blank? || user_params[:password].blank?
      return render_unauthorized errors: { unauthenticated: ["Incomplete credentials"]}
    end
  end

  def invalid_login_attempt
    render_unauthorized errors: { password: "Mot de passe erroné" }
  end

  def invalid_user
    render_unauthorized errors: { email: "Utilisateur introuvable" }
  end
end
