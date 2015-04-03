class RegistrationsController < Devise::RegistrationsController
	protected

	
  #  def after_inactive_sign_up_path_for(resource)
  #  	byebug
  #    case resource
  #    	when :guest, Guest
  #    	  edit_guest_profile_path(resource)
  #    	when :host, Host
  #    	  edit_host_profile_path(resource)
  #    	else
  #    	  super
  #    	end 
  #  end

 	# def after_sign_in_path_for(resource_or_scope)
  #     case resource_or_scope
  #       when :guest, Guest
  #         store_location = session[:forwarding_url]
  #         (store_location.nil?) ? "/" : store_location.to_s
  #       when :host, Host
  #         store_location = session[:forwarding_url]  
  #         (store_location.nil?) ? "/" : store_location.to_s
  #       else
  #         super
  #       end
  #   end   
end
