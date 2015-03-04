# class RegistrationsController < Devise::RegistrationsController
# 	protected

# 	def after_sign_up_path_for(resource)
# 		edit_guest_profile(current_guest.profile) if current_guest
# 	end

# 	def after_sign_in_path_for(resource)
# 		current_guest_path if current_guest
# 	end
# end
