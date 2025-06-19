class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create show ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render json: { error: "Rate limit exceeded. Try again later." }, status: :too_many_requests }

  def new
  end

  def show
    if resume_session
      render json: { user: Current.session.user }
    else
      render json: { error: 'Not authenticated' }, status: :unauthorized
    end
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      render json: { user: user, message: 'Login successful' }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    terminate_session
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end
