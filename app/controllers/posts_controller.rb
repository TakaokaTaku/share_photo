class PostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,   only: :destroy

  def index
    if params[:content].present?
      @posts = Post.where('content LIKE ?', "%#{params[:content]}%").paginate(page: params[:page], per_page: 9)
    else
      @posts = Post.none.paginate(page: params[:page], per_page: 9)
    end
  end

  def show
    @post = Post.find(params[:id])
    @lists = @post.comments.paginate(page: params[:page])
    @minititle = "コメント"
  end

  def new
    @post  = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.image.attach(params[:post][:image])
    if @post.save
      flash[:success] = "投稿しました"
      redirect_to current_user
    else
      render 'new'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to current_user
  end

  def likers
    @post = Post.find(params[:id])
    @lists = @post.likers.paginate(page: params[:page])
    @minititle = "お気に入り"
    render 'show'
  end

  private

    def post_params
      params.require(:post).permit(:content, :image)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end
