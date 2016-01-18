require 'jwt'

# @see: http://nebulab.it/blog/authentication-with-rails-jwt-and-react/
# A handler for the JWT gem 
class JsonWebToken
  def self.encode(payload, expiration = 24.hours.from.now)
    payload = payload.dup
    payload['exp'] = expiration.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    body = JWT.decode(token, Rails.application.secrets.secret_key_base).first
    HashWithIndifferentAccess.new body
  rescue
    # we don't need to trow errors, just return nil if JWT is invalid or expired
    nil
  end
end
