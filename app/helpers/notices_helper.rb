module NoticesHelper

  def unchecked_notices
    @notices = current_user.passive_notices.where(checked: false)
  end

end
