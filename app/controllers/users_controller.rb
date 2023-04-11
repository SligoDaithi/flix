class UsersController < ApplicationController 

  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update]
  before_action :require_admin, only: :destroy 

  def index
    @users = User.all 
  end

  def show 
    @user = User.find(params[:id])
  end

  def new 
    @user = User.new()
  end

  def create
    @user = User.new(user_params)
    if @user.save 
      session[:user_id] = @user.id
      redirect_to @user, message: "User '#{@user.name}' successfully created!"
    else 
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "User '#{@user.name}' successfully updated!" 
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy 
    @user = User.find(params[:id])
    @user.destroy 
    redirect_to root_url, status: :see_other, alert: "User '#{@user.name}' successfully deleted!"
  end

  private 

  def require_correct_user
    @user = User.find(params[:id])
    redirect_to root_url, status: :see_other unless current_user?(@user)
  end

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
  end
end
