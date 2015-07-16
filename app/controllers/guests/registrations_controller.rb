class Guests::RegistrationsController < Devise::RegistrationsController

  def create
    super
    session[:omniauth] = nil unless @user.new_record?
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

   private

     def build_resource(*args)
       super
       if session[:omniauth]
         @user.apply_omniauth(session[:omniauth])
         @user.valid?
       end
     end
end
