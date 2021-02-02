class NoticesController < ApplicationController
  before_action :logged_in_user

  def index
    notices = current_user.passive_notices
                           .paginate(page: params[:page], per_page: 20)
    notices.where(checked: false).each do |notice|
      notice.update(checked: true)
    end
    @notices = notices.where.not(visitor_id: current_user.id)
  end
end
