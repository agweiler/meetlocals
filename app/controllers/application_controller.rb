class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  include SessionHelper

  protected

	def configure_permitted_parameters
	  devise_parameter_sanitizer.for(:sign_up) << :username
	end

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

 def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when :guest, Guest
      store_location = session[:forwarding_url]
      session.delete(:forwarding_url)
      (store_location.nil?) ? "/" : store_location.to_s

    when :host, Host
      store_location = session[:forwarding_url]
      session.delete(:forwarding_url)
      (store_location.nil?) ? "/" : store_location.to_s
    else
      super
    end
  end


 	# alias_method :after_sign_in_path_for, :after_sign_up_path_for
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::RoutingError, with: :unknown_error
  private

    def record_not_found
      # render plain: "404 Not Found", status: 404
      respond_to do |format|
        format.html { redirect_to error_404_path, notice: '404'}
      end
    end

    def unknown
      respond_to do |format|
        format.html { redirect_to error_500_path, notice: '500'}
      end
    end
end
