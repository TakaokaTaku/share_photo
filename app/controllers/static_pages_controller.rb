class StaticPagesController < ApplicationController
  before_action :logged_in_user,     only: [:search]

  def home
    if logged_in?
      @post  = current_user.posts.build
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 9)
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  def search
  end
end
