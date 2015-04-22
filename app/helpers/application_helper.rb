module ApplicationHelper

  def current_user
    if current_host
      current_host
    elsif current_guest
      current_guest
    elsif
      current_admin
    end
  end

  def destroy_user_session_path
    if current_guest
      destroy_guest_session_path
    elsif current_host
      destroy_host_session_path
    elsif current_admin
      destroy_admin_session_path
    end
  end
end
