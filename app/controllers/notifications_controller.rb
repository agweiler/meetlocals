class NotificationsController < ApplicationController
  def all
  	if no_one_signed_in?
  		redirect_to '/'
  	else
  		@notifications = current_guest.notifications.sort_by { |m| [m.updated_at].max }.reverse! if guest_signed_in?
  		@notifications = current_host.notifications.sort_by { |m| [m.updated_at].max }.reverse!  if host_signed_in?
  	end
  end
end
