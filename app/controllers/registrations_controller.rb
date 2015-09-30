class RegistrationsController < Devise::RegistrationsController

  def create
    super
    session[:omniauth] = nil unless @guest.new_record?
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

   def update_resource(resource, params)
     @guest.update_attributes(params.except(:current_password))
   end

   private

     def build_resource(*args)
       super
       if session[:omniauth]
         @guest.apply_omniauth(session[:omniauth])
         @guest.valid?
       end
     end
end
