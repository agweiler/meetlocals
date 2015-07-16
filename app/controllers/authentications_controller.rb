class AuthenticationsController < ApplicationController
  def index
    @authentications = current_guest.authentications if current_guest
  end

  def create
    auth = request.env["omniauth.auth"]
    current_guest.authentications.find_or_create_by(
     provider:auth['provider'], uid:auth['uid'])
    flash[:notice] = "Authentication successful."
    redirect_to authentications_path
  end

  def destroy
    @authentication = current_guest.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_path
  end
end
