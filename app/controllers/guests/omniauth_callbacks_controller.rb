class Guests::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    login_or_create_guest
  end

  def facebook
    login_or_create_guest
  end

  # def instagram
  #   login_or_create_guest
  # end

  # def pinterest
  #   login_or_create_guest
  # end

  # def google_oauth2
  #   login_or_create_guest
  # end

  protected
    # This is necessary since Rails 3.0.4
    # See https://github.com/intridea/omniauth/issues/185
    # and http://www.arailsdemo.com/posts/44
    def handle_unverified_request
      true
    end

  private

    def login_or_create_guest
      omniauth = request.env["omniauth.auth"]
      authentication = Authentication.find_by(
       provider: omniauth['provider'],
       uid: omniauth['uid'])

      if authentication
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:guest, authentication.guest)
      elsif current_guest
        current_guest.authentications.create!(
          provider: omniauth['provider'], uid: omniauth['uid'])
        flash[:notice] = "Authentication successful."
        redirect_to authentications_path
      else
        guest = Guest.new
        guest.apply_omniauth(omniauth)

        if guest.save
          flash[:notice] = "Signed in successfully."
          sign_in_and_redirect(:guest, guest)
        else
          session[:omniauth] = omniauth.except('extra')
          redirect_to new_guest_registration_path
        end
      end
    end
end
