class Guests::RegistrationsController < Devise::RegistrationsController
 	protected

 	def after_sign_up_path_for(resource)
    	edit_guest_profile_path(resource)
 	end

 	def after_sign_in_path_for(resource)
		edit_guest_profile_path(resource)
	end
end