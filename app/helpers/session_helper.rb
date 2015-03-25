module SessionHelper

	def deny_access
		store_location
    redirect_to new_guest_session_path
	end

	def store_location
		session[:forwarding_url] = request.url if request.get?
	end
end
