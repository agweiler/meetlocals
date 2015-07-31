class AuthenticationsController < ApplicationController
  def index
    if current_guest
      @authentications = current_guest.authentications
      redirect_to edit_guest_registration_path
    else
      redirect_to home_path
    end
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
