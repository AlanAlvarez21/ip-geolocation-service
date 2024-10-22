class Auth::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = generate_token(user.id)
      render json: { message: 'Logged in successfully', token: token }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def destroy
    render json: { message: 'Logged out successfully' }
  end

  private

  def generate_token(user_id)
    expiration_time = Time.now.to_i + 3600 # 1 hora de expiración
    payload = { user_id: user_id, exp: expiration_time }
    JWT.encode(payload, ENV['APP_SECRET_KEY'], 'HS256')
  end
end