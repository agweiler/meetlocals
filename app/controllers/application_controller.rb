class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?



   	

  protected

	  def configure_permitted_parameters
	    devise_parameter_sanitizer.for(:sign_up) << :username
	  end

	  def after_sign_in_path_for(resource)
   		case resource
   		when :host, Host
        if current_host.sign_in_count == 1
    		  edit_host_profile_path(resource)
        else
          root_path
        end  
    	when :guest, Guest
        if current_guest.sign_in_count == 1
    		  edit_guest_profile_path(resource)
        else
          root_path
        end
    	else
    		super
    	end
 	  end


 	# alias_method :after_sign_in_path_for, :after_sign_up_path_for
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
end