# app/services/authorize_api_request.rb
class AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end
  
  def call
    user
  end
  
  private
  
  attr_reader :headers
  
  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
  rescue ActiveRecord::RecordNotFound
    raise StandardError, 'Invalid token - user not found'
  end
  
  def decoded_auth_token
    @decoded_auth_token ||= JwtService.decode(http_auth_header)
  end
  
  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    end
    raise StandardError, 'Missing Authorization header'
  end
end