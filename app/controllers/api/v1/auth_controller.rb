# app/controllers/api/v1/auth_controller.rb
class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:register, :login]
  
  def register
    user = User.new(user_params)
    
    if user.save
      token = JwtService.encode(user_id: user.id)
      render json: {
        success: true,
        token: token,
        user: user_response(user),
        message: 'Account created successfully'
      }, status: :created
    else
      render json: {
        success: false,
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  
  def login
    user = User.find_by(email: params[:email]&.downcase)
    
    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)
      render json: {
        success: true,
        token: token,
        user: user_response(user),
        message: 'Login successful'
      }
    else
      render json: {
        success: false,
        error: 'Invalid email or password'
      }, status: :unauthorized
    end
  end
  
  def profile
    render json: {
      success: true,
      user: user_response(current_user)
    }
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, 
                                 :first_name, :last_name, :phone, :role)
  end
  
  def user_response(user)
    {
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      full_name: user.full_name,
      role: user.role,
      created_at: user.created_at
    }
  end
end