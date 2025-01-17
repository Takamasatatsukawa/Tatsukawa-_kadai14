class UsersController < ApplicationController
  before_action :correct_user, only: [:show]
  skip_before_action :login_required, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to new_order_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    ActiveRecord::Base.transaction do
    @user = User.lock.find(params[:id])
    @user.name = "admin"
    @user.save!
    end
    
    unless current_user?(@user)
      redirect_to current_user 
  end
 end
end
