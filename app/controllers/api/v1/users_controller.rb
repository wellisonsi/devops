class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :destroy]
  respond_to :json
  wrap_parameters :user, include: [:email, :password, :password_confirmation]

  def show
    begin
      @user = User.find(params[:id])
      respond_with @user
    rescue
      head :not_found
    end
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end

  end


  def update
      user = current_user

      if user.update(user_params)
        render json: user, status: :ok
      else
        render json: { errors: user.errors }, status: :unprocessable_entity
      end
  end

  def destroy
    user = current_user
    user.destroy
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
