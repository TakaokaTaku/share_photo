class FavoritesController < ApplicationController
  before_action :logged_in_user

  def create
    @post = Post.find(params[:liked_id])
    current_user.like(@post)
    @post.create_notice_like(current_user)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end

  def destroy
    @post = Favorite.find(params[:id]).liked
    current_user.unlike(@post)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end

end
