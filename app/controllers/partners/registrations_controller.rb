class Partners::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  def create
    @image_file = sign_up_params.delete(:image_file)
    build_resource(sign_up_params.except(:image_file))
    resource.save
    Image.create(local_image: @image_file, imageable: @partner)
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?

        set_flash_message :notice, :signed_up if is_flashing_format?
        # sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      # set_minimum_password_length
      respond_with resource
    end
  end

  protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.for(:sign_up) do |u|
          u.permit(:name, :contact_info, :address,
            :email, :password, :password_confirmation,:image_file)
        end
      end
end