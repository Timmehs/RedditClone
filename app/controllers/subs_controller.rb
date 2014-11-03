class SubsController < ApplicationController
  before_action :redirect_if_non_moderator, only: [:edit, :update]

  def index
    
  end

  def show
    @sub = Sub.find(params[:id])
  end

  def new
    @sub = Sub.new
  end

  def create
    @sub = current_user.subs.new(sub_params)
    if @sub.save
      flash.now[:notice] = ["#{@sub.title} created."]
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
    @sub = Sub.find(params[:id])
  end

  def update
    @sub = Sub.find(params[:id])
    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  def destroy
  end

  def sub_params
    params.require(:sub).permit(:title, :description)
  end

  def redirect_if_non_moderator
    unless current_user == Sub.find(params[:id]).moderator
      redirect_to subs_url
    end
  end



end
