class PostsController < ApplicationController

  before_action :redirect_if_not_author, only: [:edit, :update]
  def show
    @post = Post.find(params[:id])
  end

  def index
    @posts = Post.all
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.set_post_subs(params[:post][:subs])

    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      @post.set_post_subs(params[:post][:subs])
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def destroy
    # do me later ;)
  end

  def redirect_if_not_author
    unless current_user == Post.find(params[:id]).author
      redirect_to subs_url
    end
  end

  def post_params
    params.require(:post).permit(:title, :url, :content, :subs)
  end
end
