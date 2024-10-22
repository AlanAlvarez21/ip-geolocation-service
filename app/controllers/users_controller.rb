class UsersController < ApplicationController

    def create
      @user = User.new(user_params)
      if @user.save
        render json: { message: 'Registration successful. Please log in.' }, status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def add_admin
      email = params[:email]
      @user = User.find_by(email: email)
  
      if @user
        @user.update(role: :admin)
        render json: { message: 'User is now an admin' }, status: :ok
      else
        render json: { errors: 'No user with that Email found' }, status: :not_found
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end
  

#   curl -X POST http://localhost:3000/users -H "Content-Type: application/json" -d '{
#   "user": {
#     "name": "admin",
#     "email": "admin@example.com",
#     "password": "abcd1234"
#   }
# }'

#   curl -X POST http://localhost:3000/auth/login \
# -H "Content-Type: application/json" \
# -d '{
#   "email": "admin@example.com",
#   "password": "abcd1234"
# }'