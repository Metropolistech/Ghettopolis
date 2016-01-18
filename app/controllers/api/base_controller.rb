require 'json_web_token'

class Api::BaseController < ActionController::Base
  include ActionController::ImplicitRender
  respond_to :json

  before_filter :authenticate_user_from_jwt!

  payload_error = { errors: { unauthorized: ["You are not authorized perform this action."]} }

  protected

  def current_user
    if token_from_request.blank?
      nil
    else
      authenticate_user_from_jwt!
    end
  end
  # To current_user became devise_current_user
  alias_method :devise_current_user, :current_user

  def user_signed_in?
    !current_user.nil?
  end
  alias_method :devise_user_signed_in?, :user_signed_in?

  def authenticate_user_from_jwt!
    if claims and user = User.find_by(email: claims.first['user']) and user.valid_password?(claims.first['password'])
      @current_user = user
    else
      return render_unauthorized
    end
  end

  def claims
    JsonWebToken.decode(token_from_request)
    rescue
      nil
  end

  def render_unauthorized(payload = payload_error)
    render json: payload.merge(response: {code: 401}), status: 401
  end

  def token_from_request
    auth_header = request.headers['Authorization'] and token = auth_header.split(' ').last
    if token.to_s.empty?
      return render_unauthorized
    end
    token
  end
end
