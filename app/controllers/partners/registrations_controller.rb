class Partners::RegistrationsController < Devise::RegistrationsController
	 before_filter :configure_permitted_parameters

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :contact_info, :address,
        :email, :password, :password_confirmation)
    end
  end
end