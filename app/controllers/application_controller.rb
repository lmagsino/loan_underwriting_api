# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  before_action :authenticate_request
  
  attr_reader :current_user
  
  private
  
  def authenticate_request
    @current_user = AuthorizeApiRequest.new(request.headers).call
  rescue StandardError => e
    render json: { error: e.message }, status: :unauthorized
  end
  
  def authenticate_request!
    render json: { error: 'Not authorized' }, status: :unauthorized unless current_user
  end
end