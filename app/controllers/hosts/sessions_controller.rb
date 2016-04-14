class Hosts::SessionsController < Devise::SessionsController

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    if resource.approved == false
      respond_with resource, location: host_edit_path(resource)
    else
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

end