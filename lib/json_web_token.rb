require 'jwt'

# @see: http://nebulab.it/blog/authentication-with-rails-jwt-and-react/
# A handler for the JWT gem
class JsonWebToken
  def self.encode(payload, expiration = 24.hours.from_now)
    payload = payload.dup
    payload['exp'] = expiration.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base).first
    rescue
      # we don't need to trow errors, just return nil if JWT is invalid or expired
      nil
  end

  def self.create_user_payload(user)
    { user_id: user.id }
  end
end
