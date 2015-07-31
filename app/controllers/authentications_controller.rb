class AuthenticationsController < ApplicationController
  def index
    @authentications = current_guest.authentications if current_guest
    redirect_to home_path unless current_guest
  end

  def destroy
    @authentication = current_guest.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    # redirect_to authentications_path
    redirect_to edit_guest_registration_path
  end

  protected
    # This is necessary since Rails 3.0.4
    # See https://github.com/intridea/omniauth/issues/185
    # and http://www.arailsdemo.com/posts/44
    def handle_unverified_request
      true
    end
end
