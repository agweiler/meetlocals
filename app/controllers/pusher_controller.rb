class PusherController < ApplicationController
  include ApplicationHelper
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action

  def auth
    Pusher.app_id = ENV["PUSHER_APP_ID"]
    Pusher.key = ENV["PUSHER_KEY"]
    Pusher.secret = ENV["PUSHER_SECRET"]

    if current_host && params[:channel_name] == "private-host-#{current_host.id}"
      response = Pusher[params[:channel_name]].authenticate(params[:socket_id])
      render :json => response
    else
      render :text => "Not authorized", :status => '403'
    end
  end
end