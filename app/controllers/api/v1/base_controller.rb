require 'json_web_token'

class Api::V1::BaseController < ActionController::Base
  include ActionController::ImplicitRender
  respond_to :json

  before_action :authenticate_user_from_token!
  before_action :verify_user_confirmation!

  protected

  def current_user
    if token_from_request.blank?
      nil
    else
      authenticate_user_from_token!
    end
  end
  # To current_user became devise_current_user
  alias_method :devise_current_user, :current_user

  def user_signed_in?
    !current_user.nil?
  end
  alias_method :devise_user_signed_in?, :user_signed_in?

  def authenticate_user_from_token!
    if claims and user = User.find(claims['user_id'])
      @user = user
    else
      return render_unauthorized
    end
  end

  def verify_user_confirmation!
    current_user.confirmed? ? current_user : render_unauthorized(payload = [Confirmation: "You have to confirm your account."])
  end

  def claims
    begin
      JsonWebToken.decode(token_from_request)
    rescue
      nil
    end
  end

  def render_unauthorized(payload = [Authorization: "You are not authorized perform this action."])
    res_send data: payload, status: 401, error: true
  end

  def token_from_request
    auth_header = request.headers['Authorization'] and @auth_token = auth_header.split(' ').last
    if @auth_token.to_s.empty?
      @auth_token = params[:token]
    end
    @auth_token
  end
end
