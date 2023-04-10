class UsersController < ApplicationController 
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
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: "User '#{@user.name}' successfully updated!" 
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy 
    @user = User.find(params[:id])
    @user.destroy 
    session[:user_id] = nil
    redirect_to movies_url, status: :see_other, alert: "User '#{@user.name}' successfully deleted!"
  end

  private 

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
  end
end
