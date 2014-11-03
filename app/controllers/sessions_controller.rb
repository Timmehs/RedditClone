class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, except: :destroy
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(username: sesh_params[:username])

    if @user.nil?
      @user = User.new
      flash.now[:errors] = ["User not found" ]
      render :new
    elsif !@user.is_password?(sesh_params[:password])
      flash.now[:errors] = ["password invalid"]
      render :new
    else
      login!(@user)
      redirect_to subs_url
    end
  end

  def destroy
    logout
    redirect_to new_session_url
  end

  def sesh_params
    params.require(:session).permit(:username, :password)
  end
end
