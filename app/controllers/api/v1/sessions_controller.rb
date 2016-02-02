class Api::V1::SessionsController < ApplicationController
  skip_before_filter :authenticate_user_from_token!
  before_filter :ensure_params_exist

  # POST /api/session
  def create
    if claims
      return open_session
    else
      return create_session
    end
  end

  def create_session
    @user = User.find_for_database_authentication(email: user_params[:email])

    return invalid_user unless @user
    return invalid_login_attempt unless @user.valid_password?(user_params[:password])

    @auth_token = JsonWebToken.encode(JsonWebToken.create_user_payload(@user))
    res_send data: { user: @user, token: @auth_token }, status: 201
  end

  def open_session
    authenticate_user_from_token!
    res_send data: { user: @user, token: @auth_token }, status: 201
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
    rescue
      nil
  end

  def user_params_blank?
    return user_params.blank? || user_params[:email].blank? || user_params[:password].blank?
  end

  def ensure_params_exist
    if user_params_blank? && claims.blank?
      res_send data: [createSession: "Missing required user parameter"], error: true
    end
  end

  def invalid_login_attempt
    render_unauthorized [password: "Mot de passe erroné"]
  end

  def invalid_user
    render_unauthorized [email: "Utilisateur introuvable"]
  end
end
