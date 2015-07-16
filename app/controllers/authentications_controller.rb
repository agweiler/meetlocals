class AuthenticationsController < ApplicationController
  def index
    @authentications = current_guest.authentications if current_guest
  end

  # def create
  #   auth = request.env["omniauth.auth"]
  #   current_guest.authentications.find_or_create_by(
  #    provider:auth['provider'], uid:auth['uid'])
  #   flash[:notice] = "Authentication successful."
  #   redirect_to authentications_path
  # end

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by(
     provider: omniauth['provider'],
     uid: omniauth['uid'])

    if authentication
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_guest
      current_guest.authentications.create!(
        provider: omniauth['provider'], uid: omniauth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to authentications_path
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_path
      end
    end
  end

  def destroy
    @authentication = current_guest.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_path
  end

  protected
    # This is necessary since Rails 3.0.4
    # See https://github.com/intridea/omniauth/issues/185
    # and http://www.arailsdemo.com/posts/44
    def handle_unverified_request
      true
    end
end
