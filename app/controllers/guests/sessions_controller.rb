class Guests::SessionsController < Devise::SessionsController

	def create
	  self.resource = warden.authenticate!(auth_options)
	  set_flash_message(:notice, :signed_in) if is_flashing_format?
	  sign_in(resource_name, resource)
	  yield resource if block_given?
	  if resource.filled == false
	  	redirect_to edit_guest_path(resource)
	  else
	  	respond_with resource, location: after_sign_in_path_for(resource)
	  end
	end

	def new
		if request.referrer
			session[:host_page] = request.referrer if request.referrer.include? "experiences"
		end
	  self.resource = resource_class.new(sign_in_params)
	  clean_up_passwords(resource)
	  yield resource if block_given?
	  respond_with(resource, serialize_options(resource))
	end
end