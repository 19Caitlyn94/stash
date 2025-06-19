class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    render json: { error: 'Not implemented' }, status: :not_implemented
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for(@user)
      render json: { user: @user, message: 'Account created successfully.' }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:email_address, :password, :password_confirmation)
    end
end 
