class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_action :authenticate_user!, only: [:create, :destroy]


  def index
    @comments = Comment.all
  end

  def new
    @comment = Comment.new
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    @comment.user =  current_user
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @post}
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
      format.js
    end
  end

  def destroy

    authorize! :destroy, @comment

    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @post }
      format.json { head :no_content }
      format.js
    end

  end

  private

    def set_comment
      @post = Post.find(params[:post_id])
      @comment = @post.comments.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end

end
