module SessionHelper

	def deny_access_guest
		store_location
    redirect_to new_guest_session_path
	end

	def deny_access_host
		store_location
		redirect_to new_host_session_path
	end

	def store_location
		session[:forwarding_url] = request.url if request.get?
	end

	def no_one_signed_in?
		current_host == nil && current_guest == nil && current_admin == nil
	end
end
