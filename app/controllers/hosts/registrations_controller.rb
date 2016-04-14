class Hosts::RegistrationsController < Devise::RegistrationsController

  protected
    def after_inactive_sign_up_path_for(resource)
     case resource
     	when :guest, Guest
     	  edit_guest_profile_path(resource)
     	when :host, Host
     	  edit_host_path(resource)
     	else
     	  super
     	end 
   end

end

