class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :unlike]
  before_action :authenticate_user!, except: [:index, :show]


  def index
    @posts = Post.all.order('created_at DESC')
  end

  def show
    @comments = @post.comments
  end

  def new
    authorize! :create, @post
    @post = Post.new
  end

  def edit
    authorize! :update, @post
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, @post
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
      format.js
    end
  end

  def like
    @post.liked_by current_user

    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end

  end

  def unlike
    @post.unliked_by current_user

    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end

  end

  def favorite
    @posts = current_user.find_liked_items
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end

end
