class CommentsController < ApplicationController

  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_sender, only: :destroy


  def create
    @comment = current_user.comments.build(comment_params)
    @post = Post.find(@comment.getter_id)
    if @comment.save
      @post.create_notice_comment(current_user, @comment.id)
      flash[:success] = "コメントを投稿しました"
      redirect_to @post
    else
      flash[:danger] = "コメント内容を入力してください"
      redirect_to @post
    end
  end

  def destroy
    @post = Post.find(@comment.getter_id)
    @comment.destroy
    flash[:success] = "コメントを削除しました"
    redirect_to @post
  end

  private

  def comment_params
    params.require(:comment).permit(:getter_id, :content)
  end

  def correct_sender
    @comment = current_user.comments.find(params[:id])
    redirect_to root_url if @comment.nil?
  end

end
