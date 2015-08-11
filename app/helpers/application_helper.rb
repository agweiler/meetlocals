module ApplicationHelper

  def current_user
    if current_host
      current_host
    elsif current_guest
      current_guest
    elsif current_admin
      current_admin
    elsif current_partner
      current_partner
    end
  end

  def destroy_user_session_path
      destroy_guest_session_path
      destroy_host_session_path
      destroy_admin_session_path
  end
end
