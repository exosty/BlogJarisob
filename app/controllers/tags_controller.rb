class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :destroy]

  def index
    @tags = Tag.all.order('created_at DESC')
  end

  def show
  end

  def new
    @tag = Tag.new
  end

  def create
    @post = Tag.find(params[:tag_id])
    @tag = @post.tags.create(tag_params)
  end

  def destroy
    authorize! :destroy, @tag
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to tags_url }
      format.json { head :no_content }
      format.js
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

end
