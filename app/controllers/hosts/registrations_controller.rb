class Hosts::RegistrationsController < Devise::RegistrationsController

  def destroy
    resource.experiences do |exp|
        exp.bookings.delete_all
    end
    resource.experiences.delete_all
    resource.delete
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  protected
    def after_inactive_sign_up_path_for(resource)
     case resource
     	when :guest, Guest
     	  edit_guest_profile_path(resource)
     	when :host, Host
     	  edit_host_profile_path(resource)
     	else
     	  super
     	end 
   end

end

