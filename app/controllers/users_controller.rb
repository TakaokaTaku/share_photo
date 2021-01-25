class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :correct_user,     only: [:edit, :update, :destroy]

  def index
    if params[:name].present?
      @users = User.where('name LIKE ?', "%#{params[:name]}%").paginate(page: params[:page])
    else
      @users = User.paginate(page: params[:page])
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def edit_password
    @user = User.find(params[:id])
  end

  def update_password
    @user = User.find(params[:id])
    if @user.authenticated?('password', params[:user][:present_password])
      if @user.update(user_params)
        flash[:success] = "パスワードを更新しました"
        redirect_to @user
      else
        flash.now[:danger] = '無効なパスワードです'
        render 'edit_password'
      end
    else
      flash.now[:danger] = 'パスワードが一致していません'
      render 'edit_password'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :user_name, :picture, :introduction,
                                 :website, :email, :tel, :gender, :password,
                                 :password_confirmation, :present_password)
  end

  # beforeアクション

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

end
