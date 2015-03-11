class MessagesController < ApplicationController

  def new
    @message = params[:message]
    new_message = Message.create(text: @message[:text],
                    sender_id: @message[:sender_id],
                    sender_type: @message[:sender_type],
                    booking_id: @message[:booking_id]  )

    booking = new_message.booking
    if new_message.sender_type == "host"

      guest = Guest.find(booking.guest_id)
      Guestmailer.guest_get_mail(guest,booking).deliver_now
    elsif new_message.sender_type == "guest"

      host = Host.find(booking.experience.host_id)
      Hostmailer.host_get_mail(host,booking).deliver_now
    end

    # redirect_to booking_path new_message.booking_id
    respond_to do |format|
      format.html {redirect_to booking_path new_message.booking_id}
      format.js
    end
  end

end
