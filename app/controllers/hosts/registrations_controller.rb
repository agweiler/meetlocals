class Hosts::RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    edit_host_profile_path(resource)
  end

end